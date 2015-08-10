//
//  RewardListViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardViewController.h"


@interface RewardListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) RewardViewController * rewardViewController;
@property (strong, nonatomic) IBOutlet UITableView *rewardTable;
- (IBAction)btnRewieRewardsTapped:(UIButton *)sender;

@end
