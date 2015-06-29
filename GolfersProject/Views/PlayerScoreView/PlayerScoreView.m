//
//  EventHeader.m
//  GolfersProject
//
//  Created by Zubair on 6/1/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PlayerScoreView.h"

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
        [self setBackgroundColor:[UIColor blackColor]];

    }
    return self;
}

- (IBAction)btnDropDownTap:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownTapped)]) {
        [self.delegate dropDownTapped];
    }
}
- (IBAction)btnEditScoreTap:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editScoreTappedForPlayer:)]) {
        [self.delegate editScoreTappedForPlayer:player];
    }
}

-(void)configureViewForPlayer:(id)mPlayer hideDropdownBtn:(BOOL)yesNo{
    
    player = mPlayer;
    [self.btnShowTable setHidden:yesNo];
    

    
}
@end
