//
//  EventAdminViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/29/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarEvent.h"
#import "EventAdmin.h"

@interface EventAdminViewController : UIViewController

@property (strong, nonatomic) CalendarEvent * currentEvent;

@property (strong, nonatomic) IBOutlet UIImageView *imgEventLogo;

@property (strong, nonatomic) IBOutlet UILabel *lblEventName;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblCourseName;
@property (strong, nonatomic) IBOutlet UILabel *lblStreetAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblState;
@property (strong, nonatomic) IBOutlet UILabel *lblCity;
@property (strong, nonatomic) IBOutlet UILabel *lblPostalCode;
@property (strong, nonatomic) IBOutlet UILabel *lblViewMap;
@property (strong, nonatomic) IBOutlet UILabel *lblEventLocation;

@property (strong, nonatomic) IBOutlet UIImageView *imgAdminPic;
@property (strong, nonatomic) IBOutlet UILabel *lblAdminName;
@property (strong, nonatomic) IBOutlet UILabel *lblAdminPost;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblContactNo;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;

@end
