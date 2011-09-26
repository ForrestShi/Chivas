//
//  cocos2d2AppDelegate.m
//  cocos2d2
//
//  Created by forrest on 10-8-6.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ChivasAppDelegate.h"
#import "cocos2d.h"


#import "PanelViewController.h"
#import "GameLayerScene.h"
#import "OpenFlowViewController.h"
#import "MainViewController.h"
#import "VideoPlaybackViewController.h"

@implementation ChivasAppDelegate

@synthesize window,backgroundView,mainViewController;


- (void)dealloc {
	[[CCDirector sharedDirector] release];
	
	if (mainViewController) {
		[mainViewController release];
	}
	
	[backgroundView release];
	[window release];
	[super dealloc];
}


#pragma mark Application lifecycle

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// CC_DIRECTOR_INIT()
	//
	// 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
	// 2. EAGLView multiple touches: disabled
	// 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
	// 4. Parents EAGLView to the newly created window
	// 5. Creates Display Link Director
	// 5a. If it fails, it will use an NSTimer director
	// 6. It will try to run at 60 FPS
	// 7. Display FPS: NO
	// 8. Device orientation: Portrait
	// 9. Connects the director to the EAGLView
	//
	//CC_DIRECTOR_INIT();
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];					
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )								
		[CCDirector setDirectorType:kCCDirectorTypeNSTimer];									
	CCDirector *__director = [CCDirector sharedDirector];										
	[__director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];								
	[__director setDisplayFPS:NO];																
	[__director setAnimationInterval:1.0/60];
	
	//do not use EAGLView here , use UIKit
	//EAGLView *__glView = [EAGLView viewWithFrame:[window bounds]								
//									 pixelFormat:kEAGLColorFormatRGB565							
//									 depthFormat:0 /* GL_DEPTH_COMPONENT24_OES */				
//							  preserveBackbuffer:NO];											
//	[__director setOpenGLView:__glView];														
//	[window addSubview:__glView];																
	[window makeKeyAndVisible];	
	
	// Obtain the shared director in order to...
	CCDirector *director = [CCDirector sharedDirector];
	
	// Sets landscape mode
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	
	// Turn on display FPS
	[director setDisplayFPS:NO];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];	
	
	
	//background view 
	backgroundView = nil;
	if (backgroundView == nil) {
		backgroundView = [[PanelViewController alloc] init];
	}
	
	[self startChivasShow];
 
	//[self switchToCoverFlow:0];
	
}

- (void) switchToViewController:(UIViewController*) newViewController  withIndex:(int)index
{
#ifdef DEBUG
	NSLog(@"%s \n",__FUNCTION__);
#endif
	
	if (newViewController) {
		[backgroundView setupWithCenterViewController:newViewController withIndex:index];
		//[newViewController release];
		[self.window addSubview: backgroundView.view];
	}
	
}

- (void) switchToMatchCardGame{
	NSLog(@"%s",__FUNCTION__);
	//clear all views
	if (backgroundView) {
		[backgroundView setupGameViewController];
	}
//	
	[[CCDirector sharedDirector] runWithScene: [GameLayer scene]];
	
}

- (void) endMatchCardGame{
	NSLog(@"%s",__FUNCTION__);
	//[[CCDirector sharedDirector] end];
	CC_DIRECTOR_END();
	[self switchToCoverFlow: 3];
	
}

// index indicate which coverview is at top 
- (void) switchToCoverFlow:(int) index {
#ifdef DEBUG
	MYLog();
#endif
	
	if (mainViewController) {
		[mainViewController.view removeFromSuperview];
	}

	
		OpenFlowViewController *coverflow = [[OpenFlowViewController alloc]initWithCoverIndex:index];
		[backgroundView setupWithCenterViewController:coverflow withIndex:-1];
		[coverflow release];
	

	
	[self.window addSubview:backgroundView.view];
	
}


- (void) startChivasShow{
	
	mainViewController = [[MainViewController alloc]init];
	mainViewController.view.alpha = 1.0;
	[window addSubview:mainViewController.view];
}
- (void) responseToClick1{
	//NSLog(@"response to clicke");
	[UIView beginAnimations:@"test" context:nil];
	[UIView setAnimationDuration:.2];
	mainViewController.view.alpha = 0;
//	userInputViewController.view.alpha = 1.0;
//	[mainViewController.view removeFromSuperview];
//	[window addSubview:userInputViewController.view];
	[UIView commitAnimations];

	//start playing video 
		
	[NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(startPlayvideo) userInfo:nil repeats:NO];
	//[self switchToCoverFlow:0];
	//[self startPlayvideo];
}

- (void) startPlayvideo {
	if (mainViewController) {
		[mainViewController.view removeFromSuperview];
		[mainViewController release];
		mainViewController = nil;
	}
	
	// -2 play video 
	
	//CGRect videoRect = CGRectMake(VIDEO_X, VIDEO_Y, VIDEO_W, VIDEO_H);
	VideoPlaybackViewController* videoPlayView = [[VideoPlaybackViewController alloc] 
												  init];
	//videoPlayView.view.frame = CGRectMake(VIDEO_X,VIDEO_Y, VIDEO_W/2,VIDEO_H/2);
	//[mainViewController.view addSubview:videoPlayView];
	//[self switchToViewController:videoPlayView withIndex:0];
	//backgroundView.view.frame =  CGRectMake(COVERFLOW_X,COVERFLOW_Y, VIDEO_W,VIDEO_H);
	[backgroundView setupVideoplay:videoPlayView];
	[videoPlayView release];
	
	[self.window addSubview:backgroundView.view];
	
}

- (void) enableBackButton:(Boolean)flag{
	if (backgroundView) {
		[backgroundView enableBackButton:flag];
	}
}

- (void) enableNextButton:(Boolean)flag{
	if (backgroundView) {
		[backgroundView enableNextButton:flag];
	}
}

- (void) enablePreButton:(Boolean)flag{
	if (backgroundView) {
		[backgroundView enablePreButton:flag];
	}
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CC_DIRECTOR_END();
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}




@end
