/**
 * Copyright (c) 2009 Alex Fajkowski, Apparent Logic LLC
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
#import "AFOpenFlowView.h"
#import "AFOpenFlowConstants.h"
#import "AFUIImageReflection.h"

#define COVER_BUFFER 6  //6

@interface AFOpenFlowView (hidden)

- (void)resetDataState;
- (void)setUpInitialState;
- (AFItemView *)coverForIndex:(int)coverIndex;
- (void)updateCoverImage:(AFItemView *)aCover;
- (AFItemView *)dequeueReusableCover;
- (void)layoutCovers:(int)selected fromCover:(int)lowerBound toCover:(int)upperBound;
- (void)layoutCover:(AFItemView *)aCover selectedCover:(int)selectedIndex animated:(Boolean)animated;
- (AFItemView *)findCoverOnscreen:(CALayer *)targetLayer;

@end

@implementation AFOpenFlowView



@synthesize dataSource; 
@synthesize viewDelegate;
@synthesize numberOfImages; 
@synthesize defaultImage;
@synthesize selectedCoverView;

@synthesize offscreenCovers;
@synthesize onscreenCovers;
@synthesize coverImages;
@synthesize coverImageHeights;

- (void)dealloc {
	self.dataSource = nil; 
	self.viewDelegate = nil; 
	self.defaultImage = nil; 
	self.selectedCoverView = nil; 
	
	self.offscreenCovers = nil; 
	self.onscreenCovers = nil;
	self.coverImages = nil; 
	self.coverImageHeights = nil; 
	
	[scrollView release];
	[flipViewShown release];
	
	[super dealloc];
}

#pragma mark Accessor 

- (void) setDataSource:(id <AFOpenFlowViewDataSource>)ds {
	if (ds != dataSource) {
		[ds retain]; 
		[dataSource release];
		dataSource = ds; 
		[self reloadData];
	}
}

#pragma mark Hidden Implementation details

- (void)resetDataState {
	// Set up the default image for the coverflow.
	self.defaultImage = [self.dataSource defaultImage];
	
	// Create data holders for onscreen & offscreen covers & UIImage objects.
	self.coverImages = [[NSMutableDictionary alloc] init];
	self.coverImageHeights = [[NSMutableDictionary alloc] init];
	self.offscreenCovers = [[NSMutableSet alloc] init];
	self.onscreenCovers = [[NSMutableDictionary alloc] init];
}

- (void)setUpInitialState {
	[self resetDataState]; 
	
	scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
	scrollView.userInteractionEnabled = YES; //NO;
	scrollView.multipleTouchEnabled = YES;//NO;
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:scrollView];
	
	self.multipleTouchEnabled = YES;//NO;
	self.userInteractionEnabled = YES;
	self.autoresizesSubviews = YES;
	self.layer.position=CGPointMake(self.frame.origin.x + self.frame.size.width / 2, self.frame.origin.y + self.frame.size.height / 2);
	
	// Initialize the visible and selected cover range.
	lowerVisibleCover = upperVisibleCover = -1;
	selectedCoverView = nil;
	
	// Set up the cover's left & right transforms.
	leftTransform = CATransform3DIdentity;
	leftTransform = CATransform3DRotate(leftTransform, SIDE_COVER_ANGLE, 0.0f, 1.0f, 0.0f);
	rightTransform = CATransform3DIdentity;
	rightTransform = CATransform3DRotate(rightTransform, SIDE_COVER_ANGLE, 0.0f, -1.0f, 0.0f);
	
	// Set some perspective
	CATransform3D sublayerTransform = CATransform3DIdentity;
	sublayerTransform.m34 = -0.01;
	[scrollView.layer setSublayerTransform:sublayerTransform];
	
	flipViewShown = nil;
	
	flippedContainerView = [[UIView alloc] initWithFrame:self.frame];
	[self addSubview:flippedContainerView];
	
	[self setBounds:self.frame];
}

- (AFItemView *)coverForIndex:(int)coverIndex {
	AFItemView *coverView = [self dequeueReusableCover];
	
	if (!coverView) {
		coverView = [[[AFItemView alloc] initWithFrame:CGRectZero] autorelease];
	}
	
	coverView.backgroundColor = self.backgroundColor;
	coverView.number = coverIndex;
	return coverView;
}

- (void)updateCoverImage:(AFItemView *)aCover {
	NSNumber *coverNumber = [NSNumber numberWithInt:aCover.number];
	UIImage *coverImage = (UIImage *)[coverImages objectForKey:coverNumber];
	if (coverImage) {
		NSNumber *coverImageHeightNumber = (NSNumber *)[coverImageHeights objectForKey:coverNumber];
		if (coverImageHeightNumber)
			[aCover setImage:coverImage originalImageHeight:[coverImageHeightNumber floatValue] reflectionFraction:kReflectionFraction];
	} else {
		[aCover setImage:defaultImage originalImageHeight:defaultImageHeight reflectionFraction:kReflectionFraction];
		[self.dataSource openFlowView:self requestImageForIndex:aCover.number];
	}
}

- (AFItemView *)dequeueReusableCover {
	AFItemView *aCover = [offscreenCovers anyObject];
	if (aCover) {
		[[aCover retain] autorelease];
		[offscreenCovers removeObject:aCover];
	}
	return aCover;
}

- (void)layoutCover:(AFItemView *)aCover selectedCover:(int)selectedIndex animated:(Boolean)animated  {
	int coverNumber = aCover.number;
	CATransform3D newTransform;
	CGFloat newZPosition = SIDE_COVER_ZPOSITION;
	CGPoint newPosition;
	
	newPosition.x = halfScreenWidth + aCover.horizontalPosition;
	newPosition.y = halfScreenHeight + aCover.verticalPosition;
	if (coverNumber < selectedIndex) {
		newPosition.x -= CENTER_COVER_OFFSET;
		newTransform = leftTransform;
	} else if (coverNumber > selectedIndex) {
		newPosition.x += CENTER_COVER_OFFSET;
		newTransform = rightTransform;
	} else {
		newZPosition = 0;
		newTransform = CATransform3DIdentity;
	}
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationBeginsFromCurrentState:YES];
	}
	
	aCover.opaque = NO; 
	aCover.layer.transform = newTransform;
	aCover.layer.zPosition = newZPosition;
	aCover.layer.position = newPosition;
	
	if (animated) {
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(layoutCoverAnimationDidStop:finished:context:)];
		[UIView commitAnimations];
	}
}

- (void)layoutCovers:(int)selected fromCover:(int)lowerBound toCover:(int)upperBound {
	AFItemView *cover;
	NSNumber *coverNumber;
	for (int i = lowerBound; i <= upperBound; i++) {
		coverNumber = [[NSNumber alloc] initWithInt:i];
		cover = (AFItemView *)[onscreenCovers objectForKey:coverNumber];
		[coverNumber release];
		[self layoutCover:cover selectedCover:selected animated:YES];
	}
}

- (AFItemView *)findCoverOnscreen:(CALayer *)targetLayer {
	// See if this layer is one of our covers.
	NSEnumerator *coverEnumerator = [onscreenCovers objectEnumerator];
	AFItemView *aCover = nil;
	while (aCover = (AFItemView *)[coverEnumerator nextObject])
		if ([[aCover.imageView layer] isEqual:targetLayer])
			break;
	
	return aCover;
}

#pragma mark View Management 

- (void)awakeFromNib {
	[self setUpInitialState];
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setUpInitialState];
	}
#ifdef	DEBUG
	NSLog(@"initWithFrame  %s ,%d  %d \n ", __FUNCTION__ , __LINE__ ,selectedCoverView.number );
#endif
	return self;
}

- (void) layoutSubviews {
	halfScreenWidth = self.bounds.size.width / 2;
	halfScreenHeight = self.bounds.size.height / 2;
	
	int lowerBound = MAX(-1, selectedCoverView.number - COVER_BUFFER);
	int upperBound = MIN(self.numberOfImages - 1, selectedCoverView.number + COVER_BUFFER);
	
	[self layoutCovers:selectedCoverView.number fromCover:lowerBound toCover:upperBound];
	[self centerOnSelectedCover:NO];
}	

- (void)setNumberOfImages:(int)newNumberOfImages {
	numberOfImages = newNumberOfImages;
	scrollView.contentSize = CGSizeMake(newNumberOfImages * COVER_SPACING + self.bounds.size.width, self.bounds.size.height);

	int lowerBound = MAX(0, selectedCoverView.number - COVER_BUFFER);
	int upperBound = MIN(self.numberOfImages - 1, selectedCoverView.number + COVER_BUFFER);
	
	if (selectedCoverView)
		[self layoutCovers:selectedCoverView.number fromCover:lowerBound toCover:upperBound];
	else
		[self setSelectedCover:0];
	
	[self centerOnSelectedCover:NO];
}

- (void)setDefaultImage:(UIImage *)newDefaultImage {
	[defaultImage release];
	defaultImageHeight = newDefaultImage.size.height;
	defaultImage = [[newDefaultImage addImageReflection:kReflectionFraction] retain];
}

- (void)setImage:(UIImage *)image forIndex:(int)index {
	// Create a reflection for this image.
	UIImage *imageWithReflection = [image addImageReflection:kReflectionFraction];
	NSNumber *coverNumber = [NSNumber numberWithInt:index];
	[coverImages setObject:imageWithReflection forKey:coverNumber];
	[coverImageHeights setObject:[NSNumber numberWithFloat:image.size.height] forKey:coverNumber];
	
	// If this cover is onscreen, set its image and call layoutCover.
	AFItemView *aCover = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:index]];
	if (aCover) {
		[aCover setImage:imageWithReflection originalImageHeight:image.size.height reflectionFraction:kReflectionFraction];
		[self layoutCover:aCover selectedCover:selectedCoverView.number animated:NO];
	}
}

#pragma mark Touch management 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint startPoint = [[touches anyObject] locationInView:self];
	isDraggingACover = NO;
	
	// Which cover did the user tap?
	CALayer *targetLayer = (CALayer *)[scrollView.layer hitTest:startPoint];
	AFItemView *targetCover = [self findCoverOnscreen:targetLayer];
	isDraggingACover = (targetCover != nil);

	beginningCover = selectedCoverView.number;
	// Make sure the user is tapping on a cover.
	//why divide by 1.5  fshi ?
	startPosition = (startPoint.x / 1.5) + scrollView.contentOffset.x;
	
	if (isSingleTap)
		isDoubleTap = YES;
		
	isSingleTap = ([touches count] == 1);
    
    // Begin of animation 
    // XXX This is more the beginning of touch as animation...
//    if ([self.viewDelegate respondsToSelector:@selector(openFlowViewAnimationDidBegin:)])
//        [self.viewDelegate openFlowViewAnimationDidBegin:self];
	
    if ([self.viewDelegate respondsToSelector:@selector(openFlowViewScrollingDidBegin:)])
        [self.viewDelegate openFlowViewScrollingDidBegin:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	isSingleTap = NO;
	isDoubleTap = NO;
	
	// Only scroll if the user started on a cover.
	if (!isDraggingACover)
		return;
	
	CGPoint movedPoint = [[touches anyObject] locationInView:self];
	CGFloat offset = startPosition - (movedPoint.x / 1.5);
	CGPoint newPoint = CGPointMake(offset, 0);
	scrollView.contentOffset = newPoint;
	int newCover = offset / COVER_SPACING;
	if (newCover != selectedCoverView.number) {
		if (newCover < 0)
			[self setSelectedCover:0];
		else if (newCover >= self.numberOfImages)
			[self setSelectedCover:self.numberOfImages - 1];
		else
			[self setSelectedCover:newCover];
	}
	
    if ([self.viewDelegate respondsToSelector:@selector(openFlowViewAnimationDidBegin:)])
        [self.viewDelegate openFlowViewAnimationDidBegin:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (flipViewShown) {
		if (isSingleTap) {
			[self dismissFlippedSelection];
		}
		return;
	}
	
	if (isSingleTap) {
		// Which cover did the user tap?
		CGPoint targetPoint = [[touches anyObject] locationInView:self];
		CALayer *targetLayer = (CALayer *)[scrollView.layer hitTest:targetPoint];
		AFItemView *targetCover = [self findCoverOnscreen:targetLayer];
		if (targetCover && (targetCover.number != selectedCoverView.number))
			[self setSelectedCover:targetCover.number];
	}
	[self centerOnSelectedCover:YES];
	
	// And send the delegate the newly selected cover message.
	if (beginningCover == selectedCoverView.number) {
        // Tap?
        if([[event allTouches] count]==1) {
            UITouch *touch = [[event allTouches] anyObject];    
            if ([touch tapCount] == 1) {
                if ([self.viewDelegate respondsToSelector:@selector(openFlowView:didTap:)])
                    [self.viewDelegate openFlowView:self didTap:selectedCoverView.number];
            } else if ([touch tapCount] == 2) {
                if ([self.viewDelegate respondsToSelector:@selector(openFlowView:didDoubleTap:)])
                    [self.viewDelegate openFlowView:self didDoubleTap:selectedCoverView.number];            
            }   
            
        }    
    } else {
		if ([self.viewDelegate respondsToSelector:@selector(openFlowView:selectionDidChange:)])
			[self.viewDelegate openFlowView:self selectionDidChange:selectedCoverView.number];
    }
    
    // End of scrolling 
    if ([self.viewDelegate respondsToSelector:@selector(openFlowViewScrollingDidEnd:)])
        [self.viewDelegate openFlowViewScrollingDidEnd:self];    
}

- (void)centerOnSelectedCover:(BOOL)animated {
	CGPoint selectedOffset = CGPointMake(COVER_SPACING * selectedCoverView.number, 0);
	[scrollView setContentOffset:selectedOffset animated:animated];
}

- (void)reloadData {
	[self resetDataState];
	self.numberOfImages = [self.dataSource numberOfImagesInOpenView:self];
}

- (void)setSelectedCover:(int)newSelectedCover {
	
#ifdef	DEBUG
	NSLog(@"%s ,%d \n ", __FUNCTION__ , __LINE__ );
#endif
	
	if (selectedCoverView && (newSelectedCover == selectedCoverView.number)){
#ifdef	DEBUG
		NSLog(@"%s ,%d \n return ", __FUNCTION__ , __LINE__ );
#endif
		return;
	}
	
	AFItemView *cover;
	int newLowerBound = MAX(0, newSelectedCover - COVER_BUFFER);
	int newUpperBound = MIN(self.numberOfImages - 1, newSelectedCover + COVER_BUFFER);
	if (!selectedCoverView) {
#ifdef	DEBUG
		NSLog(@"%s ,%d \n selectedCoverView is nil ", __FUNCTION__ , __LINE__ );
#endif
		// Allocate and display covers from newLower to newUpper bounds.
		for (int i=newLowerBound; i <= newUpperBound; i++) {
			cover = [self coverForIndex:i];
			[onscreenCovers setObject:cover forKey:[NSNumber numberWithInt:i]];
			[self updateCoverImage:cover];
			[scrollView.layer addSublayer:cover.layer];
			//[scrollView addSubview:cover];
			[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
		}
		
		lowerVisibleCover = newLowerBound;
		upperVisibleCover = newUpperBound;
		selectedCoverView = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:newSelectedCover]];
		
		return;
	}
	
	// Check to see if the new & current ranges overlap.
	if ((newLowerBound > upperVisibleCover) || (newUpperBound < lowerVisibleCover)) {
#ifdef	DEBUG
		NSLog(@"%s ,%d \n CASE 1 ", __FUNCTION__ , __LINE__ );
#endif
		// They do not overlap at all.
		// This does not animate--assuming it's programmatically set from view controller.
		// Recycle all onscreen covers.
		AFItemView *cover;
		for (int i = lowerVisibleCover; i <= upperVisibleCover; i++) {
			cover = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:i]];
			[offscreenCovers addObject:cover];
			[cover removeFromSuperview];
			[onscreenCovers removeObjectForKey:[NSNumber numberWithInt:cover.number]];
		}
			
		// Move all available covers to new location.
		for (int i=newLowerBound; i <= newUpperBound; i++) {
			cover = [self coverForIndex:i];
			[onscreenCovers setObject:cover forKey:[NSNumber numberWithInt:i]];
			[self updateCoverImage:cover];
			[scrollView.layer addSublayer:cover.layer];
		}

		lowerVisibleCover = newLowerBound;
		upperVisibleCover = newUpperBound;
		selectedCoverView = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:newSelectedCover]];
		[self layoutCovers:newSelectedCover fromCover:newLowerBound toCover:newUpperBound];
		
		return;
	} else if (newSelectedCover > selectedCoverView.number) {
#ifdef	DEBUG
		NSLog(@"%s ,%d \n CASE 2 ", __FUNCTION__ , __LINE__ );
#endif
		// Move covers that are now out of range on the left to the right side,
		// but only if appropriate (within the range set by newUpperBound).
		for (int i=lowerVisibleCover; i < newLowerBound; i++) {
			cover = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:i]];
			if (upperVisibleCover < newUpperBound) {
				// Tack it on the right side.
				upperVisibleCover++;
				cover.number = upperVisibleCover;
				[onscreenCovers setObject:cover forKey:[NSNumber numberWithInt:cover.number]];
				[self updateCoverImage:cover];
				[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
			} else {
				// Recycle this cover.
				[offscreenCovers addObject:cover];
				[cover removeFromSuperview];
			}
			[onscreenCovers removeObjectForKey:[NSNumber numberWithInt:i]];
		}
		lowerVisibleCover = newLowerBound;
		
		// Add in any missing covers on the right up to the newUpperBound.
		for (int i=upperVisibleCover + 1; i <= newUpperBound; i++) {
			cover = [self coverForIndex:i];
			[onscreenCovers setObject:cover forKey:[NSNumber numberWithInt:i]];
			[self updateCoverImage:cover];
			[scrollView.layer addSublayer:cover.layer];
			[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
		}
		upperVisibleCover = newUpperBound;
	} else {
#ifdef	DEBUG
		NSLog(@"%s ,%d \n CASE 3 ", __FUNCTION__ , __LINE__ );
#endif
		// Move covers that are now out of range on the right to the left side,
		// but only if appropriate (within the range set by newLowerBound).
		for (int i=upperVisibleCover; i > newUpperBound; i--) {
			cover = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:i]];
			if (lowerVisibleCover > newLowerBound) {
				// Tack it on the left side.
				lowerVisibleCover --;
				cover.number = lowerVisibleCover;
				[onscreenCovers setObject:cover forKey:[NSNumber numberWithInt:lowerVisibleCover]];
				[self updateCoverImage:cover];
				[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
			} else {
				// Recycle this cover.
				[offscreenCovers addObject:cover];
				[cover removeFromSuperview];
			}
			[onscreenCovers removeObjectForKey:[NSNumber numberWithInt:i]];
		}
		upperVisibleCover = newUpperBound;
		
		// Add in any missing covers on the left down to the newLowerBound.
		for (int i=lowerVisibleCover - 1; i >= newLowerBound; i--) {
			cover = [self coverForIndex:i];
			[onscreenCovers setObject:cover forKey:[NSNumber numberWithInt:i]];
			[self updateCoverImage:cover];
			[scrollView.layer addSublayer:cover.layer];
			//[scrollView addSubview:cover];
			[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
		}
		lowerVisibleCover = newLowerBound;
	}

#ifdef	DEBUG
	NSLog(@"%s ,%d \n ", __FUNCTION__ , __LINE__ );
#endif
	if (selectedCoverView.number > newSelectedCover)
		[self layoutCovers:newSelectedCover fromCover:newSelectedCover toCover:selectedCoverView.number];
	else if (newSelectedCover > selectedCoverView.number)
		[self layoutCovers:newSelectedCover fromCover:selectedCoverView.number toCover:newSelectedCover];
	
	selectedCoverView = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:newSelectedCover]];
#ifdef	DEBUG
	NSLog(@"%s ,%d \n ", __FUNCTION__ , __LINE__ );
#endif
}

- (void)flipSelectedToView:(UIView *)flipsideView {
	// Save selected view state before animation
	flipViewShown = [[NSMutableDictionary alloc] init];
	[flipViewShown setValue:selectedCoverView.imageView forKey:@"imageView"];
	[flipViewShown setValue:flipsideView forKey:@"flipsideView"];
	
	CGRect flippedViewFrame = CGRectMake(
										 (flippedContainerView.frame.size.width-flipsideView.frame.size.width)/2,
										 flippedContainerView.frame.size.height-flipsideView.frame.size.height,
										 flipsideView.frame.size.width,
										 flipsideView.frame.size.height);
	flipsideView.frame = flippedViewFrame;
	
	double animationDuration = 0.8;
	
	// Animate flip of open flow image out of view
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
						   forView:selectedCoverView
							 cache:YES];
	[selectedCoverView.imageView removeFromSuperview];
	[UIView commitAnimations];
	
	// Animate flip of flipped view into view
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
						   forView:flippedContainerView
							 cache:YES];
	[flippedContainerView addSubview:flipsideView];
	[UIView commitAnimations];
	
}

- (void)dismissFlippedSelection {
	UIImageView *restoredImageView = [flipViewShown valueForKey:@"imageView"];
	UIView *flipsideView = [flipViewShown valueForKey:@"flipsideView"];
	
	double animationDuration = 0.8;
	
	// Animate flip of flipped view out of view
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:flippedContainerView
							 cache:YES];
	[flipsideView removeFromSuperview];
	[UIView commitAnimations];
	
	// Animate flip of image view back into view
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:selectedCoverView
							 cache:YES];
	[selectedCoverView addSubview:restoredImageView];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(dismissFlippedAnimationDidStop:finished:context:)];
	[UIView commitAnimations];
	
	flipViewShown = nil;
}

- (void)layoutCoverAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([self.viewDelegate respondsToSelector:@selector(openFlowViewAnimationDidEnd:)])
        [self.viewDelegate openFlowViewAnimationDidEnd:self];    
}

- (void)dismissFlippedAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	// Same as layoutCoverAnimationDidStop: for now
    if ([self.viewDelegate respondsToSelector:@selector(openFlowViewAnimationDidEnd:)])
        [self.viewDelegate openFlowViewAnimationDidEnd:self];    
}


@end