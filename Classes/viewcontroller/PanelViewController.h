

#import <UIKit/UIKit.h>
#import "LayoutParameters.h"

@interface PanelViewController : UIViewController  {
   
	id delegate;
	int viewIndex;
	UIViewController *centerViewController;
	UIImageView* backgroundView;
	UIImageView* goldenPowder1, *goldenPowder2;
	UIImageView* goldenCenterBackground;
	UIImageView* leaf1,*leaf2,*leaf3,*leaf4;
	UIImageView* bigChivas, *smallChivas ,*titleView;
	UIButton* backButton;
	UIButton* nextButton;
	UIButton* previousButton;
	
}
@property (nonatomic,retain) UIViewController *centerViewController;
@property (nonatomic,retain) UIImageView* backgroundView;
@property (nonatomic,retain) UIImageView* goldenPowder1;
@property (nonatomic,retain) UIImageView* goldenPowder2;
@property (nonatomic,retain) UIImageView* goldenCenterBackground;
@property (nonatomic,retain) UIImageView* leaf1;
@property (nonatomic,retain) UIImageView* leaf2;
@property (nonatomic,retain) UIImageView* leaf3;
@property (nonatomic,retain) UIImageView* leaf4;
@property (nonatomic,retain) UIImageView* bigChivas;
@property (nonatomic,retain) UIImageView* smallChivas;
@property (nonatomic,retain) UIImageView* titleView;

@property (nonatomic,retain) id delegate;
@property (nonatomic,assign) int viewIndex;
@property (nonatomic,assign) UIButton* backButton;
@property (nonatomic,assign) UIButton* nextButton;
@property (nonatomic,assign) UIButton* previousButton;


- (void) setupWithCenterViewController:(UIViewController*)controller withIndex:(int)index;

@end
