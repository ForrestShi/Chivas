//
//  ImageWithTextViewController.h
//  universaldemo
//
//  Created by forrest on 10-8-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayoutParameters.h"

@interface ImageWithTextViewController : UIViewController < BackButtonDelegate> {
	
	NSMutableArray* imageArrays;
	CGPoint startLocation;
	NSInteger currentIndex;
	UIImageView* currentImageView;
	UIImageView* nextImageView;
}
@property (nonatomic ,retain) NSMutableArray* imageArrays;
@property (nonatomic,assign) CGPoint startLocation;
@property (nonatomic, retain) UIImageView* currentImageView;
@property (nonatomic, retain) UIImageView* nextImageView;





@end
