//
//  MultipleImagesWithTextViewController.m
//  universaldemo
//
//  Created by forrest on 10-8-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "MultipleImagesWithTextViewController.h"
#import "ChivasAppDelegate.h"


@implementation MultipleImagesWithTextViewController
@synthesize detailImageViewButton;
@synthesize image1Button;
@synthesize image2Button;
@synthesize image3Button;
@synthesize image4Button;
@synthesize isDetailViewButtonNow;




- (void)dealloc {
	[image1Button release];
	[image2Button release];
	[image3Button release];
	[image4Button release];
	[detailImageViewButton release];
	
    [super dealloc];
}

- (void) backToMainMenu{
	NSLog(@"%s \n",__FUNCTION__);
	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	if (appDelegate) {
		[appDelegate switchToCoverFlow: 2];
	}
}

- (void) onClickBackButton{
#ifdef DEBUG 
	NSLog(@"%s \n",__FUNCTION__);
#endif
	if (self.isDetailViewButtonNow == TRUE) {
		//go back to last view , still in this view 
	
		[self onTapDetailImageButton:nil];
		
	}else {
		[self backToMainMenu];
	}
}



- (void) onTapDetailImageButton:(id)sender{
	
	self.isDetailViewButtonNow = FALSE;
	[UIView beginAnimations:@"test" context:nil];
	[UIView setAnimationDuration:1];
	image1Button.alpha = 1;
	image2Button.alpha = 1;
	image3Button.alpha = 1;
	image4Button.alpha = 1;
	detailImageViewButton.alpha = 0;
	[UIView commitAnimations];
	
	
}
- (void) onClickButton:(id)sender{
	NSInteger index = [sender tag];
	
	NSString* imagePath ;
	
	CGRect imageRect;
	switch (index) {
		case 1:
		{
			imagePath = @"1801-detail.png";
			imageRect = CGRectMake(IMAGE1_X, IMAGE1_Y, IMAGE_W, IMAGE_H);
			break;
		}
		case 2:
		{
			imagePath = @"1997-detail.png";
			imageRect = CGRectMake(IMAGE2_X, IMAGE2_Y, IMAGE_W, IMAGE_H);
			break;
		}
		case 3:
		{
			imagePath = @"2008-detail.png";
			imageRect = CGRectMake(IMAGE3_X, IMAGE3_Y, IMAGE_W, IMAGE_H);
			break;
		}
		case 4:
		{
			imagePath = @"2010-detail.png";
			imageRect = CGRectMake(IMAGE4_X, IMAGE4_Y, IMAGE_W, IMAGE_H);
			break;
		}
		default:
		{
			imagePath = @"1801-detail.png";
			imageRect = CGRectMake(IMAGE1_X, IMAGE1_Y, IMAGE_W, IMAGE_H);
			break;
		}
	}
	
	UIImage *image =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:imagePath ofType:nil]];
	
	if (detailImageViewButton != nil) {
		detailImageViewButton.frame = CGRectMake(DETAILIMAGE_X, DETAILIMAGE_Y, DETAILIMAGE_W, DETAILIMAGE_H);
		[detailImageViewButton setBackgroundImage:image forState:UIControlStateNormal];
		[detailImageViewButton setBackgroundImage:image forState:UIControlEventTouchDown];
		[detailImageViewButton setBackgroundImage:image forState:UIControlEventAllEvents];
	}
	
	self.isDetailViewButtonNow = TRUE;
	
	
	[UIView beginAnimations:@"test" context:nil];
	[UIView setAnimationDuration:.5];
	image1Button.alpha = 0;
	image2Button.alpha = 0;
	image3Button.alpha = 0;
	image4Button.alpha = 0;
	detailImageViewButton.alpha = 1;
	[UIView commitAnimations];
	
	
	
}	

- (UIButton*) createImageButton:(int)index{
	
	NSString* imagePath;
	CGRect imageRect;
	switch (index) {
		case 1:
		{
			imagePath = @"1801.png";
			imageRect = CGRectMake(IMAGE1_X, IMAGE1_Y, IMAGE_W, IMAGE_H);
			break;
		}
		case 2:
		{
			imagePath = @"1997.png";
			imageRect = CGRectMake(IMAGE2_X, IMAGE2_Y, IMAGE_W, IMAGE_H);
			break;
		}
		case 3:
		{
			imagePath = @"2008.png";
			imageRect = CGRectMake(IMAGE3_X, IMAGE3_Y, IMAGE_W, IMAGE_H);
			break;
		}
		case 4:
		{
			imagePath = @"2010.png";
			imageRect = CGRectMake(IMAGE4_X, IMAGE4_Y, IMAGE_W, IMAGE_H);
			break;
		}
		default:
		{
			imagePath = @"1801.png";
			imageRect = CGRectMake(IMAGE1_X, IMAGE1_Y, IMAGE_W, IMAGE_H);
			break;
		}
	}
	UIImage *image1 =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:imagePath ofType:nil]];
	
	UIButton* imageButton = [[UIButton alloc]initWithFrame:imageRect];
	//imageButton.backgroundColor =[ UIColor clearColor];
	//imageButton.opaque = NO;
	[imageButton setBackgroundImage:image1 forState:UIControlStateNormal];
	[imageButton setBackgroundImage:image1 forState:UIControlEventAllEvents];
	[imageButton addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchDown];
	imageButton.tag = index;
	
	return imageButton;
	
	
} 
- (id)init{
	
	if (self = [super init]) {
		NSLog(@"init");
		self.view.backgroundColor = [UIColor clearColor];
		self.isDetailViewButtonNow = FALSE;
		
		//UIImage *image1 =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"1801.png" ofType:nil]];
		//		UIButton* image1Button = [[UIButton alloc]initWithFrame:CGRectMake(IMAGE1_X, IMAGE1_Y, IMAGE_W, IMAGE_H)];
		//		image1Button.backgroundColor =[ UIColor clearColor];
		//		image1Button.opaque = NO;
		//		[image1Button setBackgroundImage:image1 forState:UIControlStateNormal];
		//		[image1Button setBackgroundImage:image1 forState:UIControlStateSelected];
		//		[image1Button addTarget:self action:@selector(onClickButton1:) forControlEvents:UIControlEventTouchDown];
		//		[self.view addSubview:image1Button];
		//		[image1Button release];
		
		
		image1Button = [self createImageButton:1];
		image2Button = [self createImageButton:2];
		image3Button = [self createImageButton:3];
		image4Button = [self createImageButton:4];
		[self.view addSubview:image1Button];
		[self.view addSubview:image2Button];
		[self.view addSubview:image3Button];
		[self.view addSubview:image4Button];
		
		detailImageViewButton = [[UIButton alloc] initWithFrame:CGRectMake(DETAILIMAGE_X, DETAILIMAGE_Y, DETAILIMAGE_W, DETAILIMAGE_H)];
		detailImageViewButton.alpha = 0;
		[detailImageViewButton addTarget:self action:@selector(onTapDetailImageButton:) forControlEvents:UIControlEventTouchDown];
		[self.view addSubview:detailImageViewButton];
		
		//UIImage *image2 =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"1997.png" ofType:nil] ];
		//		UIButton* image1Button = [[UIButton alloc]initWithFrame:CGRectMake(IMAGE1_X, IMAGE1_Y, IMAGE_W, IMAGE_H)];
		//		image1Button.backgroundColor =[ UIColor clearColor];
		//		image1Button.opaque = NO;
		//		[image1Button setBackgroundImage:image1 forState:UIControlStateNormal];
		//		[image1Button setBackgroundImage:image1 forState:UIControlStateSelected];
		//		[image1Button addTarget:self action:@selector(onClickButton1:) forControlEvents:UIControlEventTouchDown];
		//		[self.view addSubview:image1Button];
		//		[image1Button release];
		//
		//		UIImage *image3 =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"2008.png" ofType:nil] ];
		//		UIButton* image1Button = [[UIButton alloc]initWithFrame:CGRectMake(IMAGE1_X, IMAGE1_Y, IMAGE_W, IMAGE_H)];
		//		image1Button.backgroundColor =[ UIColor clearColor];
		//		image1Button.opaque = NO;
		//		[image1Button setBackgroundImage:image1 forState:UIControlStateNormal];
		//		[image1Button setBackgroundImage:image1 forState:UIControlStateSelected];
		//		[image1Button addTarget:self action:@selector(onClickButton1:) forControlEvents:UIControlEventTouchDown];
		//		[self.view addSubview:image1Button];
		//		[image1Button release];
		//		
		//		
		//		UIImage *image4 =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"2010.png" ofType:nil] ];
		//		UIButton* image1Button = [[UIButton alloc]initWithFrame:CGRectMake(IMAGE1_X, IMAGE1_Y, IMAGE_W, IMAGE_H)];
		//		image1Button.backgroundColor =[ UIColor clearColor];
		//		image1Button.opaque = NO;
		//		[image1Button setBackgroundImage:image1 forState:UIControlStateNormal];
		//		[image1Button setBackgroundImage:image1 forState:UIControlStateSelected];
		//		[image1Button addTarget:self action:@selector(onClickButton1:) forControlEvents:UIControlEventTouchDown];
		//		[self.view addSubview:image1Button];
		//		[image1Button release];
		
	}
	return self;
}



//- (void) addCreatedImageView:(NSString*)imagePath withRectX:(float)x withRectY:(float)y withRectW:(float)w withRectH:(float)y{
//	UIImage *image1 =[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"pic01_279x416.png" ofType:nil] ];
//	UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image1];
//	imageView1.alpha = 1;
//	imageView1.frame = CGRectMake(AGEMATTER_X, AGEMATTER_Y, AGEMATTER_W, AGEMATTER_H);
//	[self.view addSubview:imageView1];
//	[imageView1 release];
//}
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




@end
