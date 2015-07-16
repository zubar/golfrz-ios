//
//  EventHeader.m
//  GolfersProject
//
//  Created by Zubair on 6/1/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "EventHeaderView.h"

@implementation EventHeaderView

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"EventHeaderView" owner:self options:nil] lastObject];
        [self setBackgroundColor:[UIColor blackColor]];

    }
    return self;
}
@end
