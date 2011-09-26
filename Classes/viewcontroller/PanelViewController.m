

#import "PanelViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomMoviePlayerViewController.h"
#import "VideoPlaybackViewController.h"
#import "ImageWithTextViewController.h"
#import "MultipleImagesWithTextViewController.h"
#import "MatchcardGameViewController.h"
#import "PromoPageViewController.h"

@implementation PanelViewController

@synthesize centerViewController,backgroundView,leaf1,leaf2,leaf3,leaf4,goldenPowder1,goldenPowder2,goldenCenterBackground;
@synthesize delegate,viewIndex;
@synthesize backButton,nextButton,previousButton;
@synthesize bigChivas,smallChivas,titleView;

- (void)dealloc {
	
	[centerViewController release];
	[backgroundView release];
	[backButton release];
	[nextButton release];
	[previousButton release];
	[leaf1 release];
	[leaf2 release];
	[leaf3 release];
	[leaf4 release];
	[bigChivas release];
	[smallChivas release];
	[titleView release];
	[goldenPowder1 release];
	[goldenPowder2 release];
	[goldenCenterBackground release];
	
    [super dealloc];
}


- (id)init{
#ifdef DEBUG
	MYLog();
#endif
	
	if (self = [super init]) {
		self.centerViewController = nil;
		self.viewIndex = -1; //necessary to make sure hide back button
	}
	return self;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	//load background image
	if (backgroundView == nil) {
		UIImage *background =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"background-l.png" ofType:nil] ];
		backgroundView = [[UIImageView alloc] initWithImage:background];
		[self.view addSubview:backgroundView];
	}
	
	//sand
	if (goldenPowder1 == nil) {
		UIImage *background =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"sand1.png" ofType:nil] ];
		goldenPowder1 = [[UIImageView alloc] initWithImage:background];
		goldenPowder1.alpha = 0.2;
		goldenPowder1.frame = CGRectMake(SAND1_X, SAND1_Y, SAND1_W, SAND1_H);
		[self.view addSubview:goldenPowder1];
	}
	if (goldenPowder2 == nil) {
		UIImage *background =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"sand2.png" ofType:nil] ];
		goldenPowder2 = [[UIImageView alloc] initWithImage:background];
		goldenPowder2.alpha = 0.2;
		goldenPowder2.frame = CGRectMake(SAND2_X, SAND2_Y, SAND2_W, SAND2_H);
		[self.view addSubview:goldenPowder2];
	}
	
	//center golden
	if (goldenCenterBackground == nil) {
		UIImage *background =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"goldencenter.png" ofType:nil] ];
		goldenCenterBackground = [[UIImageView alloc] initWithImage:background];
		goldenCenterBackground.frame = CGRectMake(CENTERBACKGROUND_X, CENTERBACKGROUND_Y, CENTERBACKGROUND_W, CENTERBACKGROUND_H);
		[self.view addSubview:goldenCenterBackground];
	}
	
	//leaf 
	if (leaf1 == nil) {
		UIImage *leafImg1 =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"leaf01.png" ofType:nil] ];
		leaf1 = [[UIImageView alloc] initWithImage:leafImg1];
		leaf1.alpha = 1;
		leaf1.frame = CGRectMake(LEAF1_W, -LEAF1_Y, LEAF1_W, LEAF1_H);
		[self.view addSubview:leaf1];
	}
	if (leaf2 == nil) {
		UIImage *leafImg1 =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"leaf02.png" ofType:nil] ];
		leaf2 = [[UIImageView alloc] initWithImage:leafImg1];
		leaf2.alpha = 1;
		leaf2.frame = CGRectMake(LEAF2_W/2, -LEAF2_H,LEAF2_W,LEAF2_H);
		[self.view addSubview:leaf2];
	}
	if (leaf3 == nil) {
		UIImage *leafImg1 =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"leaf03.png" ofType:nil] ];
		leaf3 = [[UIImageView alloc] initWithImage:leafImg1];
		leaf3.alpha = 1;
		leaf3.frame = CGRectMake(LEAF3_X + LEAF3_W +20 , LEAF3_Y -50, LEAF3_W, LEAF3_H);
		[self.view addSubview:leaf3];
	}
	if (leaf4 == nil) {
		UIImage *leafImg1 =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"leaf04.png" ofType:nil] ];
		leaf4 = [[UIImageView alloc] initWithImage:leafImg1];
		leaf4.alpha = 1;
		leaf4.frame = CGRectMake(LEAF4_X + LEAF4_W +20 , LEAF3_Y -50, LEAF4_W, LEAF4_H);
		[self.view addSubview:leaf4];
	}
	
	//animating leaves
	[self StartLeafAnimation1];
	//[self StartLeafAnimation2];
	
}

- (void) createBigChivasAnimation{	
	if (bigChivas == nil) {
		NSArray* images = [[NSArray alloc] initWithObjects:
						   [UIImage imageNamed:@"b01.png"],
						   [UIImage imageNamed:@"b02.png"],
						   [UIImage imageNamed:@"b03.png"],
						   [UIImage imageNamed:@"b04.png"],
						   [UIImage imageNamed:@"b05.png"],
						   [UIImage imageNamed:@"b06.png"],
						   [UIImage imageNamed:@"b07.png"],	
						   [UIImage imageNamed:@"b08.png"],
						   [UIImage imageNamed:@"b09.png"],
						   [UIImage imageNamed:@"b10.png"],
						   [UIImage imageNamed:@"b11.png"],
						   [UIImage imageNamed:@"b12.png"],
						   [UIImage imageNamed:@"b13.png"],
						   [UIImage imageNamed:@"b14.png"],	
						   [UIImage imageNamed:@"b15.png"],
						   [UIImage imageNamed:@"b16.png"],
						   nil];
		
		UIImage *image =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"b01.png" ofType:nil] ];
		bigChivas = [[UIImageView alloc] initWithImage:image];
		bigChivas.alpha = 1;
		bigChivas.frame = CGRectMake(CHIVAS_BIG_X, CHIVAS_BIG_Y, CHIVAS_BIG_W, CHIVAS_BIG_H);
		bigChivas.animationImages = images;
		bigChivas.animationDuration = 2.0;
		bigChivas.animationRepeatCount = 0; 
		[bigChivas startAnimating];
		
	}
	[self.view addSubview:bigChivas];
}

- (void) createSmallChivasAnimation:(int)index{	
	if (smallChivas == nil) {
		NSArray* images = [[NSArray alloc] initWithObjects:
						   [UIImage imageNamed:@"01.png"],
						   [UIImage imageNamed:@"02.png"],
						   [UIImage imageNamed:@"03.png"],
						   [UIImage imageNamed:@"04.png"],
						   [UIImage imageNamed:@"05.png"],
						   [UIImage imageNamed:@"06.png"],
						   [UIImage imageNamed:@"07.png"],	
						   [UIImage imageNamed:@"08.png"],
						   [UIImage imageNamed:@"09.png"],
						   [UIImage imageNamed:@"10.png"],
						   [UIImage imageNamed:@"11.png"],
						   [UIImage imageNamed:@"12.png"],
						   [UIImage imageNamed:@"13.png"],
						   [UIImage imageNamed:@"14.png"],	
						   [UIImage imageNamed:@"15.png"],
						   [UIImage imageNamed:@"16.png"],
						   nil];
		
		UIImage *image =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"01.png" ofType:nil] ];
		smallChivas = [[UIImageView alloc] initWithImage:image];
		smallChivas.alpha = 1;
		smallChivas.frame = CGRectMake(CHIVAS_SMALL_X, CHIVAS_SMALL_Y, CHIVAS_SMALL_W, CHIVAS_SMALL_H);
		smallChivas.animationImages = images;
		smallChivas.animationDuration = 2.0;
		smallChivas.animationRepeatCount = 0; 
		[smallChivas startAnimating];
		
	}
	[self.view addSubview:smallChivas];
	[self createTitle:index];
}

- (void) createTitle:(int)index{
	UIImage *image;
	switch (index) {
		case 0:
		{
			image =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"title-midas.png" ofType:nil] ];
			break;
		}
		case 1:
		{
			image =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"title-age.png" ofType:nil] ];
			
			break;
		}
		case 2:
		{
			image =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"title-brand.png" ofType:nil] ];
			break;
		}
		case 3:
		{
			image =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"title-matching.png" ofType:nil] ];
			break;
		}
		case 4:
		{
			image =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"promotitle.png" ofType:nil] ];
			break;
		}
		default:
		{
			image =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"title-matching.png" ofType:nil] ];
			break;
		}
		
	}
	titleView = [[UIImageView alloc] initWithImage:image];
	titleView.frame = CGRectMake(TITLE_X, TITLE_Y, TITLE_W, TITLE_H);
	[self.view addSubview:titleView];
	[titleView release];
	

}
- (void) StartLeafAnimation1 {
	// animation of leaves
	
	[UIView beginAnimations:nil context:NULL]; 
	
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:3.0];
	[UIView setAnimationDelegate:self];
	//[UIView setAnimationRepeatCount:1e100f];  //coutless
	[UIView setAnimationRepeatCount:1];   // 1 time 
	//[UIView setAnimationRepeatAutoreverses:YES];
	
	//自然飘落
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:leaf2 cache:NO];
	
	leaf1.frame = CGRectMake(LEAF1_X, LEAF1_Y, LEAF1_W, LEAF1_H);
	//leaf1.transform = CGAffineTransformMakeRotation(360.0);
	
	//
	leaf2.frame = CGRectMake(LEAF2_X, LEAF2_Y, LEAF2_W, LEAF2_H);
	leaf2.transform = CGAffineTransformMakeRotation(5.0);
	
	leaf3.frame = CGRectMake(LEAF3_X, LEAF3_Y, LEAF3_W, LEAF3_H);
	leaf4.frame = CGRectMake(LEAF4_X, LEAF4_Y, LEAF4_W, LEAF4_H);
	//	
	goldenPowder1.alpha = 1.0;
	goldenPowder2.alpha = 1.0;
	
	[UIView commitAnimations];
}

- (void) StartLeafAnimation2 {
	// animation of leaves
	
	[UIView beginAnimations:nil context:NULL]; 
	
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:5.0];
	[UIView setAnimationDelegate:self];
	//[UIView setAnimationRepeatCount:1e100f];  //coutless
	[UIView setAnimationRepeatCount:1];   // 1 time 
	//[UIView setAnimationRepeatAutoreverses:YES];
	
	//bigChivas.animationImages	
	[UIView commitAnimations];
}


#pragma mark switch center view controller

- (void) setupVideoplay:(UIViewController*)controller {
#ifdef DEBUG
	MYLog();
#endif
	
	if (self.centerViewController != nil) {
		if (self.centerViewController.view) {
			[self.centerViewController.view removeFromSuperview];
		}
		
	}
	
	self.centerViewController = controller;
	[self.centerViewController retain];
	
	//self.centerViewController.view.frame =  CGRectMake(COVERFLOW_X,COVERFLOW_Y, COVERFLOW_WIDTH,COVERFLOW_HEIGHT);

		//common , but particular for video 
	//CGRect r = CGRectMake(VIDEO_X, VIDEO_Y, VIDEO_W/2, VIDEO_H/2);	
	
	self.delegate = (VideoPlaybackViewController*) centerViewController;
			
	
		// detail view , show its title 
	//		[bigChivas removeFromSuperview];
	//	[self createSmallChivasAnimation:index];

	
	//add "back" button
	//[self createBackButton];
	
	//self.centerViewController.view.frame = r;
	self.centerViewController.view.opaque = YES;

	[self.view addSubview:self.centerViewController.view];
	
	
	
}


- (void) setupWithCenterViewController:(UIViewController*)controller withIndex:(int)index{
#ifdef DEBUG
	MYLog();
#endif
		if (self.centerViewController != nil) {
			if (self.centerViewController.view) {
				[self.centerViewController.view removeFromSuperview];
			}
			
		}
	

	self.centerViewController = controller;
	[self.centerViewController retain];
	
	self.viewIndex = index;
	
	//common , but particular for video 
	CGRect r = CGRectMake(COVERFLOW_X,COVERFLOW_Y, COVERFLOW_WIDTH,COVERFLOW_HEIGHT);
	
	switch (index) {
		case -1:
			self.delegate = nil;
			break;
		
		case 0:
		{
			self.delegate = (VideoPlaybackViewController*) centerViewController;
			r = CGRectMake(VIDEO_X, VIDEO_Y, VIDEO_W, VIDEO_H);
			break;
		}
		case 1:
			self.delegate = (ImageWithTextViewController*) centerViewController;
			break;
		case 2:
			self.delegate = (MultipleImagesWithTextViewController*) centerViewController;
			break;
		case 3:
			self.delegate = (MatchcardGameViewController*) centerViewController;
			break;
		case 4:
			self.delegate = (PromoPageViewController*) centerViewController;
			break;
		default:
			break;
	}
	
	if (viewIndex == -1 ) {
		// cover menu , show title 
		[self createBigChivasAnimation];
		[smallChivas removeFromSuperview];
		[titleView removeFromSuperview];
	}else {
		// detail view , show its title 
		[bigChivas removeFromSuperview];
		[self createSmallChivasAnimation:index];
	}


	self.centerViewController.view.frame = r;
	self.centerViewController.view.opaque = YES;
	[self.view addSubview:self.centerViewController.view];
	
	//add "back" button
	[self createBackButton];
	if (viewIndex == 1 ) {
		[self enableBackButton:NO];
		[self createNextButton];
		[self createPreButton];
		[self enablePreButton:NO];
	}else {
		[self enableBackButton:YES];
	}


#ifdef DEBUG
	MYLog();
	NSLog(@"viewIndex  %d \n",viewIndex);
#endif
	if ( viewIndex == -1) {
		// remove back button
		if (backButton != nil) {
#ifdef DEBUG
			MYLog();
#endif
			[backButton removeFromSuperview];
			//[backButton release];
			backButton = nil;
		}
		
	}
	
}

- (void) createBackButton{
	
	if (backButton == nil && viewIndex != -1 ) {
		backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		//backButton.frame = CGRectMake(BACKBUTTON_X, BACKBUTTON_Y, 100, 35);
		CGRect fullRect = self.view.frame;
		backButton.frame = CGRectMake(BACKBUTTON_X , BACKBUTTON_Y, BACKBUTTON_W, BACKBUTTON_H);
		
		UIImage *btnNormalImg =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"button.png" ofType:nil] ];
		UIImage *btnUpImg =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"button_up.png" ofType:nil] ];
		
		[backButton setImage:btnUpImg forState:UIControlStateSelected];
		[backButton setImage:btnNormalImg forState:UIControlStateNormal];
		
		[backButton addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchDown];
		
		[self.view addSubview:backButton];
		[self enableBackButton:NO];
	}
	
	
}

- (void) createNextButton{
	
	if (nextButton == nil  ) {
		nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		nextButton.frame = CGRectMake(BACKBUTTON_X , BACKBUTTON_Y, BACKBUTTON_W, BACKBUTTON_H);
		
		UIImage *btnNormalImg =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"next.png" ofType:nil] ];
		UIImage *btnUpImg =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"next.png" ofType:nil] ];
		
		[nextButton setImage:btnUpImg forState:UIControlStateSelected];
		[nextButton setImage:btnNormalImg forState:UIControlStateNormal];
		
		[nextButton addTarget:self action:@selector(onNextButton:) forControlEvents:UIControlEventTouchDown];
		
		[self.view addSubview:nextButton];
		//[self enableNextButton:NO];
	}

}

- (void) createPreButton{
	
	if (previousButton == nil  ) {
		previousButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		previousButton.frame = CGRectMake(PREBUTTON_X , BACKBUTTON_Y, BACKBUTTON_W, BACKBUTTON_H);
		
		UIImage *btnNormalImg =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"previous.png" ofType:nil] ];
		UIImage *btnUpImg =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"previous.png" ofType:nil] ];
		
		[previousButton setImage:btnUpImg forState:UIControlStateSelected];
		[previousButton setImage:btnNormalImg forState:UIControlStateNormal];
		
		[previousButton addTarget:self action:@selector(onPreButton:) forControlEvents:UIControlEventTouchDown];
		
		[self.view addSubview:previousButton];
		//[self enablePreButton:NO];
	}
	
}


-(void) enableBackButton:(Boolean)flag{
	if (backButton) {
		if (flag == YES) {
			backButton.hidden = NO;
		}else {
			backButton.hidden = YES;
		}
	}
}

-(void) enableNextButton:(Boolean)flag{
	if (nextButton) {
		if (flag == YES) {
			nextButton.hidden = NO;
		}else {
			nextButton.hidden = YES;
		}
	}
}

-(void) enablePreButton:(Boolean)flag{
	if (previousButton) {
		if (flag == YES) {
			previousButton.hidden = NO;
		}else {
			previousButton.hidden = YES;
		}
	}
}


- (void) onClickButton:(id)sender{
    NSLog(@"%s \n",__FUNCTION__);
	[delegate onClickBackButton];
}

- (void) onNextButton:(id)sender{
    NSLog(@"%s \n",__FUNCTION__);
	[delegate onClickNextButton];
}

- (void) onPreButton:(id)sender{
    NSLog(@"%s \n",__FUNCTION__);
	[delegate onClickPreButton];
}


- (void) setupGameViewController{
	
	//remove all background views
	if (self.centerViewController.view) {
		[self.centerViewController.view removeFromSuperview];
		self.centerViewController.view = nil;
	}
	if (backgroundView) {
		[backgroundView removeFromSuperview];
		backgroundView = nil;
	}
	
	// ? check 
	self.delegate = (MatchcardGameViewController*) centerViewController;
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	return (interfaceOrientation != UIDeviceOrientationPortrait) &&
	(interfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
#ifdef DEBUG
	MYLog();
#endif
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


@end

