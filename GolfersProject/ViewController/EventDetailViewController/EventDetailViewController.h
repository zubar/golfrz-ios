//
//  EventDetailViewController.h
//  GolfersProject
//
//  Created by Zubair on 5/27/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CalendarEvent;

@interface EventDetailViewController : UIViewController

@property (strong, nonatomic) CalendarEvent * currentEvent;

@end
