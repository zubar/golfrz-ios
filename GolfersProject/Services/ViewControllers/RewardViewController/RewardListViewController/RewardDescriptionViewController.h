//
//  RewardDescriptionViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/10/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardViewController.h"
#import "BaseViewController.h"
@class Reward;



@interface RewardDescriptionViewController : UIViewController

@property(weak, nonatomic) RewardViewController * rewardViewController;

@property (strong, nonatomic) IBOutlet UIImageView *rewardImage;
@property (strong, nonatomic) IBOutlet UILabel *lblRewardName;
@property (strong, nonatomic) IBOutlet UILabel *lblRewardPoints;
@property (strong, nonatomic) IBOutlet UIView *rewardNotRedeemedView;
@property (strong, nonatomic) IBOutlet UILabel *lblPointsRequired;
@property (strong, nonatomic) IBOutlet UILabel *lblRewardDetails;
- (IBAction)btnRedeemedTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnRedeem;

@property (strong, nonatomic) Reward *currentReward;

@end
