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
#import "GameSettings.h"

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

    //check before you post notif
    //currentUserNotificationSettings
    //Extracts notification payload.
    NSLog(@"Push-Message:%@", object);
    if ((object[@"title"] != nil) && (object[@"description"] != nil)) {
        NSMutableDictionary * notif = [NSMutableDictionary new];
        [notif setObject:object[@"title"] forKey:kNotificationTitle];
        [notif setObject:object[@"description"] forKey:kNotificaationDescription];

        if(object[@"data"] != [NSNull null]){
            if(object[@"data"][@"created_at"] != nil &&  object[@"data"][@"created_at"] != [NSNull null]){
                [notif setObject:object[@"data"][@"created_at"] forKey:kNotificationTimeStamp];
            }
            if ((object[@"data"][@"type"] != nil) && ([object[@"data"][@"type"] isEqualToString:@"invitation_accepted"])) {
            [self postLocalNotificationForInvitationAcceptance];
        }}
        
        SideNotificationView * notifView = [SideNotificationView sharedInstance];
        [notifView addNotificationsArrayObject:notif];
        [UIApplication sharedApplication].applicationIconBadgeNumber = [[notifView notificationsArray] count];
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
    
    //Try sending the message again if some error occurs.
    [UtilityServices postData:params toURL:pushUrl success:^(bool status, NSDictionary *userInfo) {
        // Good keep chill.
        if (status) {
            self.isRegisteredForPush = TRUE;
        }
    } failure:^(bool status, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Can not register with Golfrz Server!" message:@"App can not register for push messages with Golfrz Server, it may cause delay in receiving updates." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];
}

-(void)postLocalNotificationForInvitationAcceptance{

    /*
     Notification will only have the data dict when a player accepts the invitation & purpose of notification is to inform the user.
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:kInviteeAcceptedInvitation object:nil];
    [[GameSettings sharedSettings] setWaitingForPlayers:NO];
    [[GameSettings sharedSettings] setIsRoundInProgress:YES];
}

@end
