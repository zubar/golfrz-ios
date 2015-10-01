//
//  SideNotificationView.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "SideNotificationView.h"
#import <UIImageView+WebCache.h>
#import "UIImageView+RoundedImage.h"
#import "SharedManager.h"
#import "NSDate+Helper.h"

@implementation SideNotificationView (private)
bool isDisplaying;
@end


@interface SideNotificationView (private_methods)
-(instancetype)init;
-(void)showNotificationInView:(UIView*)view title:(NSString *)title detail:(NSString *)description;
-(void)populateNotificationAndShow;
-(UIViewController*)topMostController;

@end

@implementation SideNotificationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (SideNotificationView *)sharedInstance {
    
    static SideNotificationView *sharedInstance = nil;
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[SideNotificationView alloc] init];
    });
    
    return sharedInstance;
}



-(void)showNotificationInView:(UIView*)view title:(NSString *)title detail:(NSString *)description timeStamp:(NSString *)dateTime{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    
    isDisplaying = true;
    [self.lblTypeOfUpdate setText:title];
    [self.lblUpdateText setText:description];
    [self.lblTimeStamp setText:[self timeAgoString:[self minutesBetween:[dateFormatter dateFromString:dateTime] andEndDate:[[NSDate date] toGlobalTime]]]];
    
    NSString * logoPath = [[SharedManager sharedInstance] logoImagePath];
    [self.imgCourseLogo sd_setImageWithURL:[NSURL URLWithString:logoPath] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imgCourseLogo setRoundedImage:image];
    }];
    
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect initalFrame = CGRectMake(-self.frame.size.width, appFrame.size.height * kSideViewOriginYPercent, kSideViewWidth, kSideViewHeight);
    [self setFrame:initalFrame];
    
    CGRect finalFrame = CGRectMake(0, self.frame.origin.y, kSideViewWidth, kSideViewHeight);
    [UIView animateWithDuration:kSideAnimationDuration animations:^{
        [self setFrame:finalFrame];
        [view addSubview:self];
    }];
}

-(CGFloat )minutesBetween:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    return fabs(([endDate timeIntervalSinceDate:startDate] / 60.0) );
}


-(NSString *)timeAgoString:(CGFloat )timeInMinutes{
    
    int timeAgo = (int)timeInMinutes;
    
    if(timeAgo <= 59){
        return [NSString stringWithFormat:@"%d Min. Ago", timeAgo];
    }else
        if((timeAgo/60) <= 24){
            return [NSString stringWithFormat:@"%d Hour Ago", timeAgo/60];
        }else{
            if(timeAgo/1440 >1)
            return [NSString stringWithFormat:@"%d Days Ago", timeAgo/1440];  // 1440 = 60* 24 
            else return [NSString stringWithFormat:@"%d Day Ago", timeAgo/1440];
            }
}

-(void)addNotificationsArrayObject:(NSDictionary *)object{
    
    [self.notificationsArray addObject:object];
    [self populateNotificationAndShow];
}

-(void)populateNotificationAndShow{
    
    if (isDisplaying ) {
        return;
    }
    
    UIViewController *controller = [self topMostController];
    
    NSDictionary * notif = [NSDictionary dictionaryWithDictionary:[self.notificationsArray firstObject]];
    [self.notificationsArray removeObject:[self.notificationsArray firstObject]];
    
    [self showNotificationInView:controller.view title:notif[kNotificationTitle] detail:notif[kNotificaationDescription] timeStamp:notif[kNotificationTimeStamp]];
}


#pragma mark - UIActions

- (IBAction)btnDismiss:(UIButton *)sender {

    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect finalFrame = CGRectMake(-self.frame.size.width, appFrame.size.height * kSideViewOriginYPercent, kSideViewWidth, kSideViewHeight);
    
    [UIView animateWithDuration:kSideAnimationDuration animations:^{
        [self setFrame:finalFrame];

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        isDisplaying = false;
    }];
    
    if ([self.notificationsArray count] > 0) {
        [self performSelector:@selector(populateNotificationAndShow) withObject:nil afterDelay:2.0];
    }else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

#pragma mark - Helper Method

-(UIViewController*)topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}


#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SideNotificationView" owner:self options:nil] firstObject];
        CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
        CGRect initalFrame = CGRectMake(-kSideViewWidth, appFrame.size.height * kSideViewOriginYPercent, kSideViewWidth, kSideViewHeight);
        [self setFrame:initalFrame];
        isDisplaying = false;
        self.notificationsArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}
@end
