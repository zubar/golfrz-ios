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


- (void)didTapRedeemButton:(UIButton *)sender {
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock(self, self.index.row);
    }
    
}


@end
