//
//  CalendarEventCell.m
//  GolfersProject
//
//  Created by Zubair on 5/27/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "CalendarEventCell.h"
#import "CalendarEvent.h"
#import "NSDate+Helper.h"
#import "Utilities.h"

@implementation CalendarEventCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)detailDisclosureTapped:(id)sender {
    
    if (self.delegate) {
        [self.delegate tappedDetailedDisclosueForEvent:self.event];
    }
}


-(void)configureViewWithEvent:(CalendarEvent *)event{
    [self setBackgroundView:nil];
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.event =event;
    
    [Utilities dateComponentsFromNSDate:self.event.dateStart components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString * minutes) {
        
        self.lbleventName.text = self.event.name;
        [self.lbleventTime setText:time];
    }];
}
@end
