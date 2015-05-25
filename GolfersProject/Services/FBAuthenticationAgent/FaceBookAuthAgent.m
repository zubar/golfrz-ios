//
//  FaceBookAuthAgent.m
//  GolfersProject
//
//  Created by Zubair on 5/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "FaceBookAuthAgent.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation FaceBookAuthAgent


+(void)signInWithFaceBook{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                
                NSLog(@"Profile- %@ Token- %@",[FBSDKProfile currentProfile], [FBSDKAccessToken currentAccessToken]);
            }
        }
    }];
}


//TODO: Save Token here.
/*
You can also track currentAccessToken changes with FBSDKAccessTokenDidChangeNotification in NSNotificationCenter. If you track someone's login state changes you can update your UI based on their state.

The iOS SDK can update currentAccessToken over time such as when the SDK refreshes a token with a longer expiration date. Therefore you should check the userInfo dictionary in the notification for FBSDKAccessTokenDidChangeUserID to be current

*/
@end
