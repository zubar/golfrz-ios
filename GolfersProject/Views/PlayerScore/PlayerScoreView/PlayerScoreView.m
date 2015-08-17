//
//  EventHeader.m
//  GolfersProject
//
//  Created by Zubair on 6/1/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PlayerScoreView.h"
#import "UIImageView+RoundedImage.h"
#import <SDWebImage/UIImageView+WebCache.h>



@implementation PlayerScoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PlayerScoreView" owner:self options:nil] lastObject];
        totalScore = 0;
        score = 0;
        [self.btnEditScore setTitle:[NSString stringWithFormat:@"%d", score] forState:UIControlStateNormal];
        [self.lblScoreForHole setText:[NSString stringWithFormat:@"%d", totalScore]];
        //[self setBackgroundColor:[UIColor blackColor]];

    }
    return self;
}

- (IBAction)btnDropDownTap:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownTapped)]) {
        [self.delegate dropDownTapped];
    }
}
- (IBAction)btnEditScoreTap:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editScoreTappedForPlayer:Player:view:)]) {
        [self.delegate editScoreTappedForPlayer:sender Player:player view:self];
    }
}

-(void)configureViewForPlayer:(id)mPlayer hideDropdownBtn:(BOOL)yesNo{
    
    player = mPlayer;
    [self.btnShowTable setHidden:yesNo];
}
@end
