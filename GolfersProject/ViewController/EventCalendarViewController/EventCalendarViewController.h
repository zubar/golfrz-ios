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

@interface EventCalendarViewController : UIViewController<VRGCalendarViewDelegate>


@property (nonatomic, retain) VRGCalendarView * calendar;
@property (nonatomic, retain) EventList * eventslist;
@property (nonatomic, retain) NSMutableArray * eventDates;
@property (nonatomic, retain) NSMutableArray * colors;

@end
