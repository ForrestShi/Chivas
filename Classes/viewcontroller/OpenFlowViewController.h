//
//  TestCoverFlow.h
//  SmallFlowDemo
//
//  Created by forrest on 10-8-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XBase.h"
#import "AFOpenFlowView.h"

#import <Foundation/Foundation.h>


@interface OpenFlowViewController : UIViewController <AFOpenFlowViewDelegate>  {
	AFOpenFlowView *myOpenFlow;
}

@property (nonatomic,retain) AFOpenFlowView* myOpenFlow;

@end
