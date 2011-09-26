//
//  MainViewController.m
//  kane
//
//  Created by forrest on 10-8-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "ChivasAppDelegate.h"

@implementation MainViewController


@synthesize backgroundButton;
//@synthesize userInputViewC;



- (id)init{
	if (self = [super init]) {
		//
		self.view.backgroundColor = [UIColor blackColor];
		NSLog(@"init");
		CGRect fullRect = [UIScreen mainScreen].applicationFrame;
		backgroundButton = [[UIButton alloc]initWithFrame:fullRect];
		UIImage *backgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logobackground.png" ofType:nil]];
		[backgroundButton setImage:backgroundImage forState:UIControlStateNormal];
		//[backgroundButton setImage:backgroundImage forState:UIControlEventAllEvents];
		
		[backgroundButton addTarget:self action:@selector(onClickBackgroundButton:) forControlEvents:UIControlEventTouchDown];
		
		backgroundButton.center = CGPointMake(fullRect.size.height/2, fullRect.size.width/2);
		backgroundButton.alpha = 1.0;
		
		//self.view.backgroundColor = [UIColor redColor];
		[self.view addSubview:backgroundButton];
	}
	return self;
	
}

- (void) onClickBackgroundButton:(id)sender{
	
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate responseToClick1];
}



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
	
	return (interfaceOrientation != UIDeviceOrientationPortrait) &&
	(interfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
	
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
