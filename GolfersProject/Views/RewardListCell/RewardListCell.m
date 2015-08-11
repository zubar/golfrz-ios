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
    [self.btnRedeem addTarget:self action:@selector(didTapRedeemButton:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

<<<<<<< HEAD
- (IBAction)btnRedeemTapped:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnRedeemTappedForCurrentCell:)])
    {
        [self.delegate btnRedeemTappedForCurrentCell:_currentReward];
    }
=======

- (void)didTapRedeemButton:(UIButton *)sender {
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock(self, self.index.row);
    }
    
>>>>>>> 8ebbf06a4d65f737e8adf745f4f84beafca2ed3d
}


@end
