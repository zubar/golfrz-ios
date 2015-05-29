//
//  AuthenticationService.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/18/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "AuthenticationService.h"
#import "APIClient.h"
#import "Constants.h"
#import <Overcoat/OVCResponse.h>

#import "User.h"
#import "UserServices.h"



@implementation AuthenticationService

+(void)loginWithUserName:(NSString *)name password:(NSString *)password success:(void (^)(bool status, User *))successBlock failure:(void (^)(bool status, NSError *error))failureBlock{

//Create our client
APIClient *apiClient = [APIClient sharedAPICLient];
    
//TODO: Write completion block here.
    
    [apiClient POST:kSignInURL parameters:[AuthenticationService paramsForLogin:name password:password] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            User * mUser =[resp result];
            //Setting current user
            [UserServices setCurrentUser:mUser];
            successBlock(true,mUser);
        }
        else
            failureBlock(false, error);
    }];
}


+(void)resetUserPassword:(NSString *)email completion:(void (^)(bool))successfullyPosted failure:(void (^)(bool status, NSError *error))failureBlock{

    APIClient *apiClient = [APIClient sharedAPICLient];
    
    NSDictionary * params = @{
                              @"email":email
                              };
    
    
    [apiClient POST:kForgetPasswordURL parameters:params completion:^(id response, NSError *error) {
        //OVCResponse * resp = response;
        if (!error) {
            //TODO: in caller of that block show alert on success.
            successfullyPosted(true);
        }
        else
            failureBlock(false, error);
    }];
}

+(void)signOutUser:(void (^)(bool status))successfullyPosted{
  
    APIClient *apiClient = [APIClient sharedAPICLient];
    
    [apiClient DELETE:kSignOutURL parameters:[AuthenticationService paramsForSignOut] completion:^(id response, NSError *error) {
        //OVCResponse * resp = response;
        if (!error) {
            //TODO: in caller of that block show alert on success.
            successfullyPosted(true);
        }
    }];
    
}

+(void)singUpUser:(NSString * )firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password  passwordConfirmation:(NSString *)passwordConfirmation memberId:(NSString *)memberID completion:(void (^)(bool status, NSError * error))block{

    APIClient *apiClient = [APIClient sharedAPICLient];
    
    NSDictionary * params = [AuthenticationService paramsForSignUp:firstName lastName:lastName email:email password:password passwordConfirmation:passwordConfirmation memberId:memberID];
    
    [apiClient POST:kSignUpURL parameters:params completion:^(id response, NSError *error) {
        if (!error) {
            block(true, nil);
        }else{
            block(false, error);
        }
        
    }];


}

//TODO: Create password reset, sign out method calls same way.



#pragma mark - Helper Methods
+(NSDictionary *)paramsForLogin:(NSString *)userName password:(NSString *)pwd{
    
    return    @{
                @"email": userName,
                @"password": pwd
                };
}

+(NSDictionary *)paramsForSignOut{
    
    
    return   @{
               @"user_login":@{
                       @"auth_token" : [[UserServices currentUser] authToken]
                       }
               };
}

+(NSDictionary *)paramsForSignUp:(NSString * )firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password  passwordConfirmation:(NSString *)passwordConfirmation memberId:(NSString *)memberID{
    
    return @{
        @"email": email,
        @"password": password,
        @"password_confirmation": passwordConfirmation,
        @"member_id": memberID,
        @"first_name": firstName,
        @"last_name": lastName
        };
}

@end
