//
//  VideoPlaybackViewController.m
//  universaldemo
//
//  Created by forrest on 10-7-31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "VideoPlaybackViewController.h"
#import "ChivasAppDelegate.h"

@implementation VideoPlaybackViewController
@synthesize player; 

- (void) backToMainMenu{
	NSLog(@"%s \n",__FUNCTION__);
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	if (appDelegate) {
		[appDelegate switchToCoverFlow: 0];
	}
}

- (id)init{
	if (self = [super init]) {
		NSLog(@"init");
		self.view.backgroundColor = [UIColor clearColor];
		
	}
	return self;
}

- (id)initWithFrame:(CGRect)centerFrame{
	if (self = [super init]) {
		NSLog(@"init");
		self.view.backgroundColor = [UIColor clearColor];
		self.view.frame = centerFrame;
	}
	return self;
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *url = [[NSBundle mainBundle] 
					 pathForResource:@"result2" 
					 ofType:@"mp4"];
	
    MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] 
														 initWithContentURL:[NSURL fileURLWithPath:url]];
    
	playerViewController.moviePlayer.scalingMode=  MPMovieScalingModeAspectFit;
	//playerViewController.moviePlayer.shouldAutoplay=YES;
	playerViewController.moviePlayer.controlStyle=MPMovieControlStyleFullscreen;
	
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self
	 selector:@selector(movieFinishedCallback:)
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:[playerViewController moviePlayer]];
	
	//CGRect fullRect = [UIScreen mainScreen].applicationFrame;
	//self.view.frame = fullRect;
	//CGRect videoRect = CGRectMake(VIDEO_X, VIDEO_Y, VIDEO_W, VIDEO_H);
	//self.view.frame = videoRect;
	playerViewController.view.frame = self.view.frame; //CGRectMake(0, 0, w, h  );
	//playerViewController.view.frame = CGRectMake(COVERFLOW_X, COVERFLOW_Y, COVERFLOW_WIDTH, COVERFLOW_HEIGHT  ); //self.view.frame;
	
	self.view.backgroundColor = [UIColor clearColor];
	playerViewController.view.backgroundColor = [UIColor clearColor];
	[self.view addSubview:playerViewController.view];
	
    //---play movie---
	player = [playerViewController moviePlayer];
	//deprecated 
	//player.movieControlMode = MPMovieControlModeHidden;
	[player setControlStyle:MPMovieControlModeVolumeOnly];
	player.backgroundView.backgroundColor = [UIColor clearColor];
	
    [player play];
	
}

- (void)  movieFinishedCallback:(NSNotification*) aNotification {
	// MPMoviePlayerController *player1 = [aNotification object];
    [[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:player];
    [player stop];
	
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate switchToCoverFlow:0];
	
}


- (void) onClickBackButton{
	
	if (player) {
#ifdef DEBUG 
		NSLog(@"%s \n",__FUNCTION__);
#endif
		[[NSNotificationCenter defaultCenter] 
		 removeObserver:self
		 name:MPMoviePlayerPlaybackDidFinishNotification
		 object:player];
		[player stop];
		//[player autorelease];
		[self backToMainMenu];
	}
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Overriden to allow any orientation.
//    return (interfaceOrientation != UIInterfaceOrientationPortrait ) && (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}

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
	//[player release];
	[player autorelease];
    [super dealloc];
}


@end
