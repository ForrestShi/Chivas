//
//  CustomMoviePlayerViewController.h
//  iPadPrototype
//
//  Created by Vincent on 10-8-10.
//  Copyright Tongji 2010. All rights reserved.
//

#import "CustomMoviePlayerViewController.h"
#import "ChivasAppDelegate.h"

#pragma mark -
#pragma mark Compiler Directives & Static Variables

@implementation CustomMoviePlayerViewController

- (void) backToMainMenu{
	NSLog(@"%s \n",__FUNCTION__);
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	if (appDelegate) {
		[appDelegate switchToCoverFlow: 0];
	}
}


- (void) onClickBackButton{
	
	if (mp) {
#ifdef DEBUG 
		NSLog(@"%s \n",__FUNCTION__);
#endif
		[[NSNotificationCenter defaultCenter] 
		 removeObserver:self
		 name:MPMoviePlayerPlaybackDidFinishNotification
		 object:mp];
		[mp stop];
		//[player autorelease];
		[self backToMainMenu];
	}
}




/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
//- (id)initWithPath:(NSString *)moviePath
- (id) init 
{
	// Initialize and create movie URL
  if (self = [super init])
  {
	//movieURL = [NSURL fileURLWithPath:moviePath];  
	  NSString *url = [[NSBundle mainBundle] 
					   pathForResource:@"testhd" 
					   ofType:@"mp4"];
	  
	  movieURL = [NSURL fileURLWithPath:url];  
     [movieURL retain];
  }
	return self;
}

/*---------------------------------------------------------------------------
* For 3.2 and 4.x devices
* For 3.1.x devices see moviePreloadDidFinish:
*--------------------------------------------------------------------------*/
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	// Unless state is unknown, start playback
	if ([mp loadState] != MPMovieLoadStateUnknown)
  {
  	// Remove observer
    [[NSNotificationCenter 	defaultCenter] 
    												removeObserver:self
                         		name:MPMoviePlayerLoadStateDidChangeNotification 
                         		object:nil];

    // When tapping movie, status bar will appear, it shows up
    // in portrait mode by default. Set orientation to landscape
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];

		// Rotate the view for landscape playback
	  [[self view] setBounds:CGRectMake(0, 0, 1024, 768)];
		[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 

		// Set frame of movieplayer
		[[mp view] setFrame:CGRectMake(0, 0, 1024, 768)];
    
    // Add movie player as subview
	  [[self view] addSubview:[mp view]];   
	  	
	  stopButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];    
	  [stopButton setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
	  [stopButton addTarget:self action:@selector(stopButtonPressed:) forControlEvents: UIControlEventTouchUpInside];    
	  [[self view] addSubview:stopButton];  

		// Play the movie
		[mp play];
	}
}

/*---------------------------------------------------------------------------
* For 3.1.x devices
* For 3.2 and 4.x see moviePlayerLoadStateChanged: 
*--------------------------------------------------------------------------*/
- (void) moviePreloadDidFinish:(NSNotification*)notification 
{
	// Remove observer
	[[NSNotificationCenter 	defaultCenter] 
													removeObserver:self
                        	name:MPMoviePlayerContentPreloadDidFinishNotification
                        	object:nil];

	// Play the movie
 	[mp play];
}

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{    
  [[UIApplication sharedApplication] setStatusBarHidden:YES];

 	// Remove observer
  [[NSNotificationCenter 	defaultCenter] 
  												removeObserver:self
  		                   	name:MPMoviePlayerPlaybackDidFinishNotification 
      		               	object:nil];

	[self dismissModalViewControllerAnimated:YES];	
}

/*---------------------------------------------------------------------------
*
*--------------------------------------------------------------------------*/
- (void) readyPlayer
{
 	mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];

  if ([mp respondsToSelector:@selector(loadState)]) 
  {
  	// Set movie player layout
  	[mp setControlStyle:MPMovieControlStyleNone];
	  [mp setRepeatMode:MPMovieRepeatModeOne];
    [mp setFullscreen:YES];

		// May help to reduce latency
		[mp prepareToPlay];

		// Register that the load state changed (movie is ready)
		[[NSNotificationCenter defaultCenter] addObserver:self 
                       selector:@selector(moviePlayerLoadStateChanged:) 
                       name:MPMoviePlayerLoadStateDidChangeNotification 
                       object:nil];
	}  
  else
  {
    // Register to receive a notification when the movie is in memory and ready to play.
    [[NSNotificationCenter defaultCenter] addObserver:self 
                         selector:@selector(moviePreloadDidFinish:) 
                         name:MPMoviePlayerContentPreloadDidFinishNotification 
                         object:nil];
  }

  // Register to receive a notification when the movie has finished playing. 
  [[NSNotificationCenter defaultCenter] addObserver:self 
                        selector:@selector(moviePlayBackDidFinish:) 
                        name:MPMoviePlayerPlaybackDidFinishNotification 
                        object:nil];
}

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) loadView
{
  [self setView:[[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease]];
  [[self view] setBackgroundColor:[UIColor blackColor]];
	

}

/*---------------------------------------------------------------------------
*  
*--------------------------------------------------------------------------*/
- (void)dealloc 
{
	[mp release];
  [movieURL release];
	[super dealloc];
}

- (void)stopButtonPressed:(UIButton *)button
{
	[mp pause];
	

}

@end
