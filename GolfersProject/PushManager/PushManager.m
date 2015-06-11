//
//  PushManager.m
//  GolfersProject
//
//  Created by Zubair on 6/8/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PushManager.h"
#import "SideNotificationView.h"
#import "UtilityServices.h"

@implementation PushManager

+ (PushManager *)sharedInstance {
    
    static PushManager *sharedInstance = nil;
    
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[PushManager alloc] init];
    });
    
    return sharedInstance;
}

-(void)setPushToken:(NSString *)tokenString{
    if (!tokenString) {
        tokenString = [[NSString alloc] initWithString:tokenString];
    }
    tokenString = tokenString;
    self.isRegisteredForPush = TRUE;
    [self postTokenToServer];
}

-(void)registerForPushMessages{

    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

-(void)addNotificationToList:(NSDictionary *)object{

    //TODO: check before you post notif
    //currentUserNotificationSettings
    
    //Extracts notification payload.
    NSDictionary * notif = @{
                             kNotificationTitle : object[@"title"],
                             kNotificaationDescription : object[@"description"]
                             };
    
    SideNotificationView * notifView = [SideNotificationView sharedInstance];
    [notifView addNotificationsArrayObject:notif];
}

-(void)postTokenToServer{
    
    NSDictionary * params = @{
                              @"token": self.pushToken
                              };
    
    [UtilityServices postData:params toURL:@"some-URL" success:^(bool status, NSDictionary *userInfo) {
        // Good keep chill.
    } failure:^(bool status, NSError *error) {
        //TODO: Try again to post.
    }];
}

@end
