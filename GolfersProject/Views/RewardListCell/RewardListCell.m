//
//  RewardListCell.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RewardListCell.h"

@interface RewardListCell (private)
@property(copy, nonatomic) void (^didTapButtonBlock)(id sender, NSInteger playercount);
@end

@implementation RewardListCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnRedeemTapped:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnRedeemTappedForCurrentCell:)])
    {
        [self.delegate btnRedeemTappedForCurrentCell:_currentReward];
    }
}



@end
