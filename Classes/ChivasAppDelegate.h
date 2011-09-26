//
//  cocos2d2AppDelegate.h
//  cocos2d2
//
//  Created by forrest on 10-8-6.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PanelViewController;
@class MainViewController ;

@interface ChivasAppDelegate : NSObject <UIApplicationDelegate> {
    
	UIWindow *window;
	//
	PanelViewController *backgroundView;
	//logo background view 
	MainViewController* mainViewController;
	
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) PanelViewController *backgroundView;
@property (nonatomic, retain) MainViewController* mainViewController;

- (void) switchToCoverFlow:(int) index ;
- (void) switchToMatchCardGame;

@end