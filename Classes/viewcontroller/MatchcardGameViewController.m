    //
//  MatchcardGameViewController.m
//  universaldemo
//
//  Created by forrest on 10-8-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameLayerScene.h"
#import "cocos2d.h"
#import "MatchcardGameViewController.h"
#import "ChivasAppDelegate.h"

@implementation MatchcardGameViewController


- (void) backToMainMenu{
	NSLog(@"%s \n",__FUNCTION__);
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	if (appDelegate) {
		[appDelegate switchToCoverFlow: 3];
	}
}

- (void) onClickBackButton{
#ifdef DEBUG 
	NSLog(@"%s \n",__FUNCTION__);
#endif
	
	NSLog(@"back button clicked");
	//go back above view 
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate endMatchCardGame];
}


- (id)init{
	
	if (self = [super init]) {
		NSLog(@"init");
		//self.view.backgroundColor = [UIColor blueColor];
		self.view.multipleTouchEnabled = YES;
		self.view.userInteractionEnabled = YES;
		self.view.backgroundColor = [UIColor clearColor];
		
		//CGRect fullWindow = [UIScreen mainScreen].applicationFrame;
		EAGLView *glview = [EAGLView viewWithFrame:CGRectMake(GAME_X, GAME_Y , GAME_W,GAME_H)];
	
		[self.view addSubview:glview];
		
		CCDirector *director = [CCDirector sharedDirector];
		[director setOpenGLView:glview];
		[director setDeviceOrientation: kCCDeviceOrientationPortrait ];//kCCDeviceOrientationLandscapeLeft];								
		
		[[CCDirector sharedDirector] runWithScene:[GameLayer scene]];
		
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
