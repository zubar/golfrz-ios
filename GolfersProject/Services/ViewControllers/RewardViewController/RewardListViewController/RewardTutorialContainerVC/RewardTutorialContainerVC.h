//
//  RewardTutorialContainerVC.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTutorialPagesCount 6

@interface RewardTutorialContainerVC : UIViewController

@property (strong, nonatomic) IBOutlet UIView *childView;
@property (assign, nonatomic) NSInteger selectedPageIndex;

-(void)cycleControllerToIndex:(NSInteger )controllerIndex;
@end
