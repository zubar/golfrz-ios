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

@implementation UserServices

static User * currentUser = nil;


+(void)setCurrentUser:(User *)mUser{
    currentUser = mUser;
}

+(User *)currentUser{
    return currentUser;
}

+(void)updateUserInfo:(NSString *)fName lastName:(NSString *)lastName email:(NSString *)email success:(void (^)(bool status, NSString * message))successBlock failure:(void (^)(bool status, NSError * error))failureBlock{
    
    //Create our client
    APIClient *apiClient = [APIClient sharedAPICLient];
    
    //TODO: Write completion block here.
    NSString * updateInfoUrl = [NSString stringWithFormat:@"%@%@", kUpdateUserInfo, [[UserServices currentUser] memberId]];
    
    [apiClient PUT:updateInfoUrl parameters:[UserServices userFirstName:fName lastName:lastName email:email] completion:^(id response, NSError *error) {
       
        OVCResponse * resp = response;
        if (!error) {
            //Setting current user
            NSString * msg = [[resp result] objectForKey:@"message"];
            successBlock(true, msg);
        }else{
            failureBlock(false, error);
        }
    }];
    
}



+(void)getUserInfo:(void (^)(bool status, User * mUser))successBlock failure:(void (^)(bool status, NSError * error))failureBlock{
   
    //Create our client
    APIClient *apiClient = [APIClient sharedAPICLient];
    //TODO: Write completion block here.
    NSString * userInfoUrl = [NSString stringWithFormat:@"%@%@", kUserInfo, [[UserServices currentUser] memberId]];
    
    [apiClient GET:userInfoUrl parameters:[UserServices userToken] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            User * newInfo =[resp result];
            //Setting current user
            User * mUser = [UserServices currentUser];
          //  mUser.firstName = newInfo.firstName;
            
            successBlock(true, newInfo);
        }else{
            failureBlock(false, error);
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

+(NSDictionary *)userFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email{
    return @{
        @"id" : [[UserServices currentUser] memberId],
        @"auth_token" : @"h2_j_l-ZDOAAjCgVZ1zXHw", //TODO:
        @"first_name" : firstName,
        @"last_name" : lastName,
        @"email" : email

    };
}

+(NSDictionary *)userToken{
    return @{
             @"auth_token" : @"-9FE6IF8OEUt_08CUVt7fw" //TODO:
             };
}

@end
