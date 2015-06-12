//
//  NSDate+convenience.m
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "AppDelegate+Push.h"
#import "SideNotificationView.h"
#import "PushManager.h"

@implementation AppDelegate (Push)


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{

    //TODO: See if we need to check localNotif: 
    UILocalNotification *localNotif =
    [userInfo objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    NSLog(@"PushReceived: %@", userInfo);
    
    PushManager * sharedPushManager = [PushManager sharedInstance];
    [sharedPushManager addNotificationToList:userInfo];
    
        //NSString *itemName = [localNotif.userInfo objectForKey:ToDoItemKey];
        //[viewController displayItem:itemName];  // custom method
        //app.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber-1;
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{

    //const void *devTokenBytes = [deviceToken bytes];
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"PushToken---%@", token);
    
    PushManager * sharedPushManager = [PushManager sharedInstance];
    [sharedPushManager setPushToken:token];
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{

    NSLog(@"UserInfoSettings:%@", notificationSettings);
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{

    NSLog(@"Fail-TO-Register-Notif: %@", error);
}

//TODO: called when user taps push alert displayed by iOS, display the internal app alert or navigate to relevant screen. 
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{


}

@end
