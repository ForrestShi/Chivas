//
//  VideoPlaybackViewController.h
//  universaldemo
//
//  Created by forrest on 10-7-31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LayoutParameters.h"

@interface VideoPlaybackViewController : UIViewController < BackButtonDelegate> {
	MPMoviePlayerController *player;
	//MPMoviePlayerViewController *playerViewController;
}

@property (nonatomic, retain ) MPMoviePlayerController *player;
//@property (nonatomic, retain ) MPMoviePlayerViewController *playerViewController;

@end
