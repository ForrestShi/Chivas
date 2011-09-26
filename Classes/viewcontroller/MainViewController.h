//
//  MainViewController.h
//  kane
//
//  Created by forrest on 10-8-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class UserInputViewController;

@interface MainViewController : UIViewController {
	UIButton* backgroundButton;
	//UserInputViewController* userInputViewC;
}

@property (nonatomic , retain ) UIButton* backgroundButton;
//@property (nonatomic , retain ) UserInputViewController* userInputViewC;

- (id)init;

@end
