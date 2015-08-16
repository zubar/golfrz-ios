//
//  PopOverCell.m
//  GolfersProject
//
//  Created by Ali Ehsan on 8/16/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PopOverCell.h"

@implementation PopOverCell

#pragma mark - init methods

- (id)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PopOverCell class]) owner:self options:nil] firstObject];
    }
    return self;
}

#pragma mark - view methods

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
