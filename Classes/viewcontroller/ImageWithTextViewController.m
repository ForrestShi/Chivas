    //
//  ImageWithTextViewController.m
//  universaldemo
//
//  Created by forrest on 10-8-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageWithTextViewController.h"
#import "ChivasAppDelegate.h"


@implementation ImageWithTextViewController

@synthesize imageArrays,startLocation,currentImageView ,nextImageView;

- (void)dealloc {
	
	[imageArrays release];
	[nextImageView release];
	
	[currentImageView release];
	
    [super dealloc];
}


- (void) backToMainMenu{
	NSLog(@"%s \n",__FUNCTION__);
	[self showPreButton:NO];
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	if (appDelegate) {
		[appDelegate switchToCoverFlow: 1];
	}
}


- (void) showBackButton:(Boolean)bShowMe{
	NSLog(@"%s \n",__FUNCTION__);
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	if (appDelegate) {
		[appDelegate enableBackButton:bShowMe];
	}
}

- (void) showNextButton:(Boolean)bShowMe{
	NSLog(@"%s \n",__FUNCTION__);
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	if (appDelegate) {
		[appDelegate enableNextButton:bShowMe];
	}
}

- (void) showPreButton:(Boolean)bShowMe{
	NSLog(@"%s \n",__FUNCTION__);
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	if (appDelegate) {
		[appDelegate enablePreButton:bShowMe];
	}
}



- (void) onClickBackButton{
#ifdef DEBUG 
		NSLog(@"%s \n",__FUNCTION__);
#endif
		
	[self backToMainMenu];
	
}

- (void) onClickNextButton{
#ifdef DEBUG 
	NSLog(@"%s \n",__FUNCTION__);
#endif
	NSLog(@"currentIndex %d ", currentIndex);
	currentImageView = (UIImageView*)[imageArrays objectAtIndex:currentIndex ];
	currentIndex++;
	NSLog(@"currentIndex %d ", currentIndex);
	[self updateImageView];
}

- (void) onClickPreButton{
#ifdef DEBUG 
	NSLog(@"%s \n",__FUNCTION__);
#endif
	NSLog(@"currentIndex %d ", currentIndex);
	currentImageView = (UIImageView*)[imageArrays objectAtIndex:currentIndex ];
	currentIndex--;
	NSLog(@"currentIndex %d ", currentIndex);
	[self updateImageView];
	
}

- (id)init{
	
	if (self = [super init]) {
	
		imageArrays = [[NSMutableArray alloc] init];
		
		//
		for (int i = 1; i < 5; i++) {
			UIImage *image1 =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"age%d.png",i] ofType:nil] ];
			
			UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image1];
			imageView1.alpha = 1;
			
			int X = (COVERFLOW_WIDTH - image1.size.width )/2;

			imageView1.frame = CGRectMake(X + 8, AGEMATTER_Y, image1.size.width, image1.size.height);
			[imageArrays addObject:imageView1];
			[imageView1 release];
		}
		currentIndex = 0;
		currentImageView = (UIImageView*)[imageArrays objectAtIndex:currentIndex ];
		nextImageView = (UIImageView*)[imageArrays objectAtIndex:(currentIndex+1) ];
		[self.view addSubview: currentImageView];
		
		[self updateImageView];		
	}
	return self;
}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	//NSLog(@"touchesBegan");
//	UITouch *touch = [[event allTouches] anyObject];
//	startLocation = [touch locationInView:self.view];
//	
//	currentImageView = (UIImageView*)[imageArrays objectAtIndex:currentIndex ];
//
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	//NSLog(@"touchesMoved");
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	//NSLog(@"touchesEnded");
//	
//	UITouch *touch = [[event allTouches] anyObject];
//	CGPoint endLocation = [touch locationInView:self.view];
//	
//	if (endLocation.x > startLocation.x) {
//		currentIndex--;
//	}else {
//		currentIndex++;
//	}
//	
//	[self updateImageView];
//
//}

- (void) updateImageView{
	if (currentIndex < 0) {
		currentIndex = 0 ;
		return;
	}else if (currentIndex > 3) {
		currentIndex = 3;
		return;
	}
	
	if (currentIndex == 0) {
		NSLog(@"currentIndex %d ", currentIndex);
		[self showPreButton:NO];
		[self showNextButton:YES];
		[self showBackButton:NO];
	}else if (currentIndex == 1 || currentIndex == 2 ) {
		NSLog(@"currentIndex %d ", currentIndex);
		[self showPreButton:YES];
		[self showNextButton:YES];
		[self showBackButton:NO];
		
	}else if (currentIndex == 3) {
		NSLog(@"currentIndex %d ", currentIndex);
		[self showPreButton:YES];
		[self showNextButton:NO];
		[self showBackButton:YES];
	}
	
	nextImageView = (UIImageView*)[imageArrays objectAtIndex:currentIndex ];
	nextImageView.alpha = 1;
	//[self.view addSubview:currentImageView];
	if (currentImageView) {
		[currentImageView removeFromSuperview];
		currentImageView = nil;
	}
	[self.view addSubview:nextImageView];

	//[UIView beginAnimations:@"test1" context:nil];
//	[UIView setAnimationDuration:1.5];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//	currentImageView.alpha = 0;
//	nextImageView.alpha = 1;
//	[UIView commitAnimations];	

}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
