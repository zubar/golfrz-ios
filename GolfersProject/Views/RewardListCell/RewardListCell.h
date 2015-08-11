//
//  RewardListCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardListCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath * index;

@property (strong, nonatomic) IBOutlet UILabel *lblPoints;
@property (strong, nonatomic) IBOutlet UILabel *lblRewardName;
@property (strong, nonatomic) IBOutlet UIButton *btnRedeem;
@property (strong, nonatomic) IBOutlet UIImageView *imgRewardImage;


- (void)setDidTapButtonBlock:(void (^)(id sender, NSInteger index))didTapButtonBlock;

@end
