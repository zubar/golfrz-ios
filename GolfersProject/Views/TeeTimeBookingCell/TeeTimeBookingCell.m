//
//  TeeTimeBookingCell.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/8/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "TeeTimeBookingCell.h"

@interface TeeTimeBookingCell ()
@property(copy, nonatomic) void (^didTapButtonBlock)(id sender, NSInteger playercount);
@property(copy, nonatomic) void (^didTapPlayerCountBtnBlock)(id sender);
@end

@implementation TeeTimeBookingCell

- (void)awakeFromNib {
    // Initialization code
    [self.btnBookTeetime addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnNoOfPlayers addTarget:self action:@selector(didTapPlayerCountBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


-(void)updateViewBtnForTeetime:(Teetime *)teetime{
    if([teetime count]) [self.btnNoOfPlayers setTitle:[[teetime count] stringValue] forState:UIControlStateNormal];
    else [self.btnNoOfPlayers setTitle:@"0" forState:UIControlStateNormal];

    if ([teetime itemId]) { // it mean teetime is already booked by someone so show update button
            [self.btnBookTeetime setTitle:@"BOOKED" forState:UIControlStateNormal];
        [self.btnNoOfPlayers setUserInteractionEnabled:NO];
        }
    else {// it mean teetime is not booked at all.
        [self.btnNoOfPlayers setUserInteractionEnabled:YES];
        [self.btnBookTeetime setTitle:@"BOOK" forState:UIControlStateNormal];
    }
}

- (void)didTapButton:(id)sender {
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock(self, [[self.btnNoOfPlayers.titleLabel text] integerValue]);
    }
}

-(void)didTapPlayerCountBtn:(id)sender{
    if (self.didTapPlayerCountBtnBlock) {
        self.didTapPlayerCountBtnBlock(sender);
    }
}
@end
