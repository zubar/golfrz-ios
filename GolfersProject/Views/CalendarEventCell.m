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
    
    self.event =event;
    self.lbleventName.text = self.event.summary;
    self.lbleventTime.text = [NSDate stringFromDate:self.event.dateStart];
}
@end
