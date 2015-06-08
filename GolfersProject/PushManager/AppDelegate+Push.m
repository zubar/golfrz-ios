//
//  NSDate+convenience.m
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "AppDelegate+Push.h"

@implementation AppDelegate (Push)


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{


}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{

    const void *devTokenBytes = [deviceToken bytes];
    //self.registered = YES;
    NSLog(@"PushToken: %@", devTokenBytes)
    //[self sendProviderDeviceToken:devTokenBytes]; // custom method
    
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{

}
@end
