//
//  RewardListCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reward;

@protocol RewardListCellDelegate <NSObject>

- (void) btnRedeemTappedForCurrentCell:(Reward *)rewardItem;

@end

@interface RewardListCell : UITableViewCell{

}
@property (assign, nonatomic) id <RewardListCellDelegate> delegate;



@property (strong, nonatomic) IBOutlet UILabel *lblPoints;
@property (strong, nonatomic) IBOutlet UILabel *lblRewardName;
@property (strong, nonatomic) IBOutlet UIButton *btnRedeem;
@property (strong, nonatomic) IBOutlet UIImageView *imgRewardImage;

- (IBAction)btnRedeemTapped:(UIButton *)sender;

@property (strong , nonatomic) Reward *currentReward;


@end
