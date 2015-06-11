//
//  SideNotificationView.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideNotificationView : UIView
@property (strong, nonatomic) IBOutlet UILabel *lblTypeOfUpdate;
@property (strong, nonatomic) IBOutlet UILabel *lblTagNo;


- (IBAction)btnDismiss:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imgCourseLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeStamp;
@property (strong, nonatomic) IBOutlet UILabel *lblUpdateText;

@property (strong, nonatomic) NSMutableArray * notificationsArray;

-(void)showNotificationInView:(UIView*)view title:(NSString *)title detail:(NSString *)description;
+ (SideNotificationView *)sharedInstance;
-(void)addNotificationsArrayObject:(NSDictionary *)object;


@end
