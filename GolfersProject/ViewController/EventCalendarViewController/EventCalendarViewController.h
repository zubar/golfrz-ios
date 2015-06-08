//
//  EventCalendarViewController.h
//  GolfersProject
//
//  Created by Zubair on 5/27/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
#import "EventList.h"
#import "CalendarEventCell.h"
#import "BaseViewController.h"

@interface EventCalendarViewController : BaseViewController <VRGCalendarViewDelegate, UITableViewDataSource, UITableViewDelegate, CalendarEventCellProtocol>


@property (nonatomic, retain) VRGCalendarView * calendar;
@property (nonatomic, retain) EventList * eventslist;
@property (retain, nonatomic) IBOutlet UITableView *eventsTableVeiw;
@property (weak, nonatomic) IBOutlet UILabel *lblNoEvents;
@end
