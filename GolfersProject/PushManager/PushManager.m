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
#import "Constants.h"
#import "UserServices.h"

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postTokenToServer) name:kUserLoginSuccessful object:nil];
    }
    return self;
}

-(void)setToken:(NSString *)tokenString{
   
    if (!self.pushToken) {
        self.pushToken = [[NSString alloc] initWithString:tokenString];
    }else{
        self.pushToken = tokenString;
    }

    if (self.pushToken && [UserServices currentToken])
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
    if (object[@"title"] && object[@"description"]) {
        NSDictionary * notif = @{
                                 kNotificationTitle : object[@"title"],
                                 kNotificaationDescription : object[@"description"]
                                 };
        
        SideNotificationView * notifView = [SideNotificationView sharedInstance];
        [notifView addNotificationsArrayObject:notif];
    }
}

-(void)postTokenToServer{
    
    if (!(self.pushToken.length >=48) || ![UserServices currentToken]) {
        return;
    }
    
    NSDictionary * params = @{
                              @"reg_id": self.pushToken,
                              @"app_bundle_id": kAppBundleId,
                              @"auth_token" : [UserServices currentToken],
                              @"user_agent" : kUserAgent
                              };
    NSString * pushUrl = [NSString stringWithFormat:@"%@%@",kBaseURL, kPushRegURL];
    
    //TODO: try sending the message again if some error occurs.
    [UtilityServices postData:params toURL:pushUrl success:^(bool status, NSDictionary *userInfo) {
        // Good keep chill.
        if (status) {
            self.isRegisteredForPush = TRUE;
        }
        
    } failure:^(bool status, NSError *error) {
        //TODO: Try again to post.
    }];
}

@end
