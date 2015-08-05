//
//  TeeTimeBookingCell.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/8/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "TeeTimeBookingCell.h"

@interface TeeTimeBookingCell ()
@property(copy, nonatomic) void (^didTapButtonBlock)(id sender);
@property(copy, nonatomic) void (^didTapPlayerCountBtnBlock)(id sender);
@end

@implementation TeeTimeBookingCell

- (void)awakeFromNib {
    // Initialization code
    [self.btnBookTeetime addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)didTapButton:(id)sender {
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock(sender);
    }
}

-(void)didTapPlayerCountBtn:(id)sender{
    if (self.didTapPlayerCountBtnBlock) {
        self.didTapPlayerCountBtnBlock(sender);
    }
}
@end
