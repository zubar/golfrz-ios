//
//  CalendarEventCell.h
//  GolfersProject
//
//  Created by Zubair on 5/27/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CalendarEventCellHeight 75
@class CalendarEvent;

@protocol CalendarEventCellProtocol
@required
-(void)tappedDetailedDisclosueForEvent:(CalendarEvent *)event;
@end


@interface CalendarEventCell : UITableViewCell


@property (retain, nonatomic) CalendarEvent * event;
@property (weak, nonatomic) IBOutlet UILabel *lbleventName;
@property (weak, nonatomic) IBOutlet UIImageView *registerCheckMark;
@property (weak, nonatomic) IBOutlet UIButton *detailDisclosureBtn;
@property (weak, nonatomic) IBOutlet UILabel *lbleventTime;

@property (weak, nonatomic) id<CalendarEventCellProtocol>delegate;

-(void)configureViewWithEvent:(CalendarEvent *)event;

- (IBAction)detailDisclosureTapped:(id)sender;

@end
