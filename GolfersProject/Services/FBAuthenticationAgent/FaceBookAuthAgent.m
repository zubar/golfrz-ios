//
//  FaceBookAuthAgent.m
//  GolfersProject
//
//  Created by Zubair on 5/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "FaceBookAuthAgent.h"
#import <AFNetworking/AFNetworking.h>

#import "Constants.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation FaceBookAuthAgent


+(void)signInWithFacebook:(void (^)(bool status, NSDictionary * userInfo))successBlock
                  failure:(void (^)(bool status, NSError * error))failureBlock{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
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
                NSLog(@"Profile- %@ Token- %@",[[FBSDKProfile currentProfile] userID], [[FBSDKAccessToken currentAccessToken] tokenString]);
                
                [FaceBookAuthAgent postFBTokenToServer:[[FBSDKAccessToken currentAccessToken] tokenString] success:^(bool status, NSDictionary *userInfo){
                    if (status) {
                        successBlock(true, userInfo);
                    }
                } failure:^(bool status, NSError *error) {
                    if (!status) {
                        failureBlock(status, error);
                    }
                }];
            }else{
                NSError * tError = [NSError errorWithDomain:@"FBError-Unknown" code:0 userInfo:nil];
                failureBlock(false, tError);
                }
            
        }
    }];
}


+(void)disConnectFBAccount
{
    FBSDKLoginManager * fbLoginAgent = [FBSDKLoginManager new];
    [fbLoginAgent logOut];

        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:nil forKey:kUSER_TOKEN];
        [defaults setValue:nil forKey:kUSER_EMAIL];
        [defaults setValue:nil forKey:kUSER_ID];
        [defaults synchronize];
    /*
     In current version of FBSDK the logOut method calls [FBSDKAccessToken setCurrentAccessToken:nil] and [FBSDKProfile setCurrentProfile:nil].
     */
}

+(BOOL)hasValidToken{

    if ([FBSDKAccessToken currentAccessToken] != nil) {
        return TRUE;
    }else
        return FALSE;
}

+(void)postFBTokenToServer:(NSString *)token
                 success:(void (^)(bool status, NSDictionary * userInfo))successBlock
                 failure:(void (^)(bool status, NSError *error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kSignUpWithFacebook parameters:[FaceBookAuthAgent paramsForFacebookSignUp:token] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (responseObject[@"status"]) {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:responseObject[@"token"] forKey:kUSER_TOKEN];
            [defaults setValue:responseObject[@"email"] forKey:kUSER_EMAIL];
            [defaults setValue:responseObject[@"id"] forKey:kUSER_ID];
            
            NSLog(@"Email: %@, Token: %@, User_Id: %@", responseObject[@"email"], responseObject[@"token"], responseObject[@"id"]);
            
            [defaults synchronize];
        }
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
    
    
}


+(NSDictionary *)paramsForFacebookSignUp:(NSString *)fbBoken{
    return @{
             @"access_token" : fbBoken,
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             };
}
/*
You can also track currentAccessToken changes with FBSDKAccessTokenDidChangeNotification in NSNotificationCenter. If you track someone's login state changes you can update your UI based on their state.

The iOS SDK can update currentAccessToken over time such as when the SDK refreshes a token with a longer expiration date. Therefore you should check the userInfo dictionary in the notification for FBSDKAccessTokenDidChangeUserID to be current

*/
@end
