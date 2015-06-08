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
@property (strong, nonatomic) IBOutlet UIImageView *imgEventLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblEventName;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEventLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblEventDetails;
- (IBAction)btnContactAdminTapped:(UIButton *)sender;
- (IBAction)btnInviteFriendsTapped:(UIButton *)sender;

@end
