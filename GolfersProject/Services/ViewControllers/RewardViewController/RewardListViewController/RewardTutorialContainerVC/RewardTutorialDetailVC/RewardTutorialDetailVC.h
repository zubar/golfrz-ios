//
//  RewardTutorialDetailVC.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardTutorialDetailVC : UIViewController
- (IBAction)rewardTutorialBtnTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *rewardTutorialBtn;
@property (strong, nonatomic) IBOutlet UILabel *tutorialDetail;

@end
