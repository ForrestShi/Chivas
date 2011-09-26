//
//  TestCoverFlow.m
//  SmallFlowDemo
//
//  Created by forrest on 10-8-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OpenFlowViewController.h"
#import "LayoutParameters.h"
#import "CustomMoviePlayerViewController.h"
#import "VideoPlaybackViewController.h"
#import "ImageWithTextViewController.h"
#import "MultipleImagesWithTextViewController.h"
#import "MatchcardGameViewController.h"
#import "ChivasAppDelegate.h"
#import "PromoPageViewController.h"


@implementation OpenFlowViewController
@synthesize myOpenFlow;

- (id) initWithCoverIndex:(int)coverIndex {
	
	if (self = [super init]) {
		//self.view.backgroundColor = [UIColor clearColor];
		myOpenFlow = [[AFOpenFlowView alloc]initWithFrame:CGRectMake(0, -COVERFLOW_HEIGHT*0.1, COVERFLOW_WIDTH, COVERFLOW_HEIGHT*1.2)];
		// Load the sample images
		NSString *imageName;
		for (int i=0; i < 5; i++) {
			imageName = [[NSString alloc] initWithFormat:@"coverflow%d.png", i];
			[myOpenFlow setImage:[UIImage imageNamed:imageName] forIndex:i];
			[imageName release];
		}
		
		[myOpenFlow setNumberOfImages:5];  
		
		if (coverIndex != -2 ) {
			[myOpenFlow setSelectedCover:coverIndex];
			[myOpenFlow setViewDelegate:self];
			[self.view addSubview:myOpenFlow];
			//[self gotoVideoPlaybackView];
			
		}else {
			// coverIndex = -2 
			// play video 
			//[self gotoVideoPlaybackView];
			VideoPlaybackViewController* videoPlayView = [[VideoPlaybackViewController alloc] init];
			ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
			[appDelegate switchToViewController:videoPlayView withIndex:-2];
		}

				
	}
	return self;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc{
       [myOpenFlow release];
    //[titleLabel_ release];
    [super dealloc];
}

// MARK: OpenFlowViewDelegate

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index {
    // Set a title showing us which is the current cover shown
    //[titleLabel_ setText:[NSString stringWithFormat:@"Item #%d", index]];
	//NSLog(@"%s \n",__FUNCTION__);
}

- (void)openFlowViewAnimationDidBegin:(AFOpenFlowView *)openFlowView {
   // [overlayView_ setAlpha:0.0];
	//NSLog(@"%s \n",__FUNCTION__);
}

- (void)openFlowViewAnimationDidEnd:(AFOpenFlowView *)openFlowView {
   // ANIMATION_BEGIN(1.75)
//    [overlayView_ setAlpha:1.0];
//    ANIMATION_END
	//NSLog(@"%s \n",__FUNCTION__);
}

//single click
- (void)openFlowView:(AFOpenFlowView *)openFlowView didTap:(int)index {
    NSLog(@"Tapped on %d", index);
    //[[[[UIAlertView alloc] initWithTitle:@"Info" message:[NSString stringWithFormat:@"You tapped on item #%d", index] delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil] autorelease] show];
	switch (index) {
		case 0:
			[self gotoVideoPlaybackView];
			break;
		case 1:
			[self gotoAgeMattersView];
			break;
		case 2:
			[self gotoBrandHistoryView];
			break;
		case 3:
			[self gotoGameView];
			break;
		case 4:
			[self gotoPromoPage];
			break;
			
		default:
			break;
	}
}

//double click
- (void)openFlowView:(AFOpenFlowView *)openFlowView didDoubleTap:(int)index {
    NSLog(@"Tapped twice on %d", index);
}



-(void)gotoVideoPlaybackView{
	VideoPlaybackViewController* videoPlayView = [[VideoPlaybackViewController alloc] init];
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate switchToViewController:videoPlayView withIndex:0];
}
-(void)gotoAgeMattersView{
	ImageWithTextViewController* ageMattersView = [[ImageWithTextViewController alloc] init];
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate switchToViewController:ageMattersView withIndex:1];
	
}
-(void)gotoBrandHistoryView{	
	MultipleImagesWithTextViewController* multipImagesView = [[MultipleImagesWithTextViewController alloc] init];
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate switchToViewController:multipImagesView withIndex:2];
	
	
}
-(void)gotoGameView{
	MatchcardGameViewController* gameView = [[MatchcardGameViewController alloc] init];
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate switchToViewController:gameView withIndex:3];
}

-(void)gotoPromoPage{	
	PromoPageViewController* multipImagesView = [[PromoPageViewController alloc] init];
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate switchToViewController:multipImagesView withIndex:4];
	
	
}

@end
