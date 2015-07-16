//
//  AddRoundPlayersView.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/15/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "AddRoundPlayersView.h"

@implementation AddRoundPlayersView


- (id)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AddRoundPlayersView" owner:self options:nil] firstObject];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
