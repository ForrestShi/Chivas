//
//  CustomMoviePlayerViewController.h
//  iPadPrototype
//
//  Created by Vincent on 10-8-10.
//  Copyright Tongji 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LayoutParameters.h"

@interface CustomMoviePlayerViewController : UIViewController < BackButtonDelegate>
{
  MPMoviePlayerController *mp;
  NSURL 									*movieURL;
	UIButton	*stopButton;
}

- (id)initWithPath:(NSString *)moviePath;
- (void)readyPlayer;

@end
