//
//  PromoPageViewController.m
//  Chivas
//
//  Created by forrest on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PromoPageViewController.h"
#import "LayoutParameters.h"
#import "ChivasAppDelegate.h"

@implementation PromoPageViewController


- (id)init{
	
	if (self = [super init]) {
		
		
		UIImage *image1 =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"promopage.png" ofType:nil] ];
		
		UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image1];
		imageView1.alpha = 1;
		int X = ( COVERFLOW_WIDTH - image1.size.width )/2;
		imageView1.frame = CGRectMake(X, PROMOPAGE_Y, image1.size.width, image1.size.height);
		
		
		[self.view addSubview: imageView1];
		[imageView1 release];
		
	}
	return self;
}


- (void) backToMainMenu{
	NSLog(@"%s \n",__FUNCTION__);
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	if (appDelegate) {
		[appDelegate switchToCoverFlow: 4];
	}
}

- (void) onClickBackButton{
#ifdef DEBUG 
	NSLog(@"%s \n",__FUNCTION__);
#endif
	[self backToMainMenu];
	
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


- (void)dealloc {
    [super dealloc];
}


@end
