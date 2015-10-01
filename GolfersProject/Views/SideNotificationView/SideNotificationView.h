//
//  SideNotificationView.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>



#define kSideAnimationDuration 0.5f
#define kSideViewHeight 90
#define kSideViewWidth 300
#define kSideViewOriginYPercent 0.8f

#define kNotificationTitle @"title"
#define kNotificaationDescription @"description"
#define kNotificationTimeStamp @"notificationCreatedTime"

@interface SideNotificationView : UIView
@property (strong, nonatomic) IBOutlet UILabel *lblTypeOfUpdate;
@property (strong, nonatomic) IBOutlet UILabel *lblTagNo;


- (IBAction)btnDismiss:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imgCourseLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeStamp;
@property (strong, nonatomic) IBOutlet UILabel *lblUpdateText;

@property (strong, nonatomic) NSMutableArray * notificationsArray;

+ (SideNotificationView *)sharedInstance;
-(void)addNotificationsArrayObject:(NSDictionary *)object;


@end
