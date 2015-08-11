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

<<<<<<< HEAD
=======
@interface RewardListCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath * index;

>>>>>>> 8ebbf06a4d65f737e8adf745f4f84beafca2ed3d
@property (strong, nonatomic) IBOutlet UILabel *lblPoints;
@property (strong, nonatomic) IBOutlet UILabel *lblRewardName;
@property (strong, nonatomic) IBOutlet UIButton *btnRedeem;
@property (strong, nonatomic) IBOutlet UIImageView *imgRewardImage;

<<<<<<< HEAD
@property (strong , nonatomic) Reward *currentReward;
=======

- (void)setDidTapButtonBlock:(void (^)(id sender, NSInteger index))didTapButtonBlock;
>>>>>>> 8ebbf06a4d65f737e8adf745f4f84beafca2ed3d

@end
