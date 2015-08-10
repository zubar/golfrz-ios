//
//  RewardListViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
<<<<<<< HEAD
@property (weak, nonatomic) IBOutlet UITableView *rewardsTable;
- (IBAction)btnViewRewardTap:(id)sender;
=======
@property (strong, nonatomic) IBOutlet UITableView *rewardTable;
- (IBAction)btnRewieRewardsTapped:(UIButton *)sender;
>>>>>>> 7919b43796364e10ff138b22f51b69ab82d6343c

@end
