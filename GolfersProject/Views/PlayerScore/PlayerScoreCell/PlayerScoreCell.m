//
//  PlayerScoreCell.m
//  GolfersProject
//
//  Created by Zubair on 6/26/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PlayerScoreCell.h"

@implementation PlayerScoreCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnScoreTapped:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editScoreTappedForPlayer:Player:view:)]) {
        [self.delegate editScoreTappedForPlayer:sender Player:self.player view:self];
    }
    
}
@end
