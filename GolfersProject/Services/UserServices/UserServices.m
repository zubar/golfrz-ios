//
//  UserServices.m
//  GolfersProject
//
//  Created by Zubair on 5/20/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "UserServices.h"
#import "User.h"
#import "APIClient.h"
#import "Constants.h"
#import "UserServices.h"
#import "AuthenticationService.h"
#import "GolfrzError.h"

@implementation UserServices

static User * currentUser = nil;


+(User *)currentUser{
    return currentUser;
}

+(void)setCurrentUSerName:(NSString *)name{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:name forKey:KUSER_NAME];
    [defaults synchronize];
}
+(NSString *)currentUserName
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:KUSER_NAME];
}


+(void)setCurrentToken:(NSString *)token{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:token forKey:kUSER_TOKEN];
    [defaults synchronize];
}
+(NSString *)currentToken{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:kUSER_TOKEN];
}

+(NSString *)currentUserId{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:kUSER_ID];

}
+(void)setCurrentUserId:(NSString *)memberId{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:memberId forKey:kUSER_TOKEN];
    [defaults synchronize];
}

+(NSString *)currentUserEmail{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:kUSER_EMAIL];
}

+(void)setCurrentUserEmail:(NSString *)email{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:email forKey:kUSER_TOKEN];
    [defaults synchronize];
    
}


+(void)updateUserInfo:(NSString *)fName
             lastName:(NSString *)lastName
                email:(NSString *)email
              phoneNo:(NSString *)phoneNo
             handicap:(NSNumber *)handicap
              success:(void (^)(bool status, NSString * message))successBlock
              failure:(void (^)(bool status, GolfrzError * error))failureBlock
{
    
    //Create our client
    APIClient *apiClient = [APIClient sharedAPICLient];
    NSString * updateInfoUrl = [NSString stringWithFormat:@"%@%@", kUpdateUserInfo, [UserServices currentUserId]];
    
    [apiClient PUT:updateInfoUrl parameters:[UserServices userFirstName:fName lastName:lastName email:email phoneNo:phoneNo handicap:handicap] completion:^(id response, NSError *error) {
        if (!error) {
            //Setting current user
            NSString * msg = @"Successfully updated";;
            successBlock(true, msg);
        }else{
            failureBlock(false, [response result]);
        }
    }];
    
}



+(void)getUserInfo:(void (^)(bool status, User * mUser))successBlock
           failure:(void (^)(bool status, GolfrzError * error))failureBlock
{
    //Create our client
    APIClient *apiClient = [APIClient sharedAPICLient];

    NSString * userInfoUrl = [NSString stringWithFormat:@"%@%@", kUserInfo, [UserServices currentUserId]];
    [apiClient GET:userInfoUrl parameters:[UserServices userToken] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
                //Setting current user
                User * mUser = [resp result];
            currentUser = mUser;
            successBlock(true, mUser);
        }else{
            failureBlock(false, [resp result]);
        }

    }];
}

/*
 {
 "flag": "changed",
 "user_email": "android.tkxel12@gmail.com",
 "message": "Your Email address got changed, to activate your account please visit your email"
 }
 */

#pragma mark - Helper Methods

+(NSDictionary *)userFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email phoneNo:(NSString *)phoneNo handicap:(NSNumber *)handicap{
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:[UserServices currentUserId] forKey:@"id"];
    [dict setObject:[UserServices currentToken] forKey:@"auth_token"];
    [dict setObject:firstName forKey:@"first_name"];
    [dict setObject:lastName forKey:@"last_name"];
    [dict setObject:email forKey:@"email"];
    [dict setObject:phoneNo forKey:@"phone_no"];

    if(handicap != nil) [dict setObject:handicap forKey:@"handicap"];
    return (NSDictionary *)dict;
}

+(NSDictionary *)userToken{
    return @{
             @"auth_token" : [UserServices currentToken]
             };
}

@end
