//
//  MultipleImagesWithTextViewController.h
//  universaldemo
//
//  Created by forrest on 10-8-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayoutParameters.h"

@interface MultipleImagesWithTextViewController : UIViewController < BackButtonDelegate>{
	
	UIButton* detailImageViewButton;
	
	UIButton *image1Button;
	UIButton *image2Button;
	UIButton *image3Button;
	UIButton *image4Button;
	
	BOOL isDetailViewButtonNow;

}

@property (nonatomic ,retain) UIButton* detailImageViewButton;
@property (nonatomic ,retain) UIButton *image1Button;
@property (nonatomic ,retain) UIButton *image2Button;
@property (nonatomic ,retain) UIButton *image3Button;
@property (nonatomic ,retain) UIButton *image4Button;
@property (nonatomic , assign)BOOL isDetailViewButtonNow;




@end
