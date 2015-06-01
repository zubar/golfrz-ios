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


+(void)loginWithUserName:(NSString *)name password:(NSString *)password success:(void (^)(bool status, NSDictionary * userInfo))successBlock failure:(void (^)(bool status, NSError *error))failureBlock{

    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    [apiClient POST:kSignInURL parameters:[AuthenticationService paramsForLogin:name password:password] success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

+(void)signOutUser:(void (^)(bool status))successfullyPosted failureBlock:(void (^)(bool status, NSError * error))failureBlock{
  
    APIClient *apiClient = [APIClient sharedAPICLient];
    
    [apiClient DELETE:kSignOutURL parameters:[AuthenticationService paramsForSignOut] completion:^(id response, NSError *error) {
        //OVCResponse * resp = response;
        if (!error) {
            //TODO: in caller of that block show alert on success.
            successfullyPosted(true);
        }else{
            failureBlock(false, error);
        }
    }];
    
}

+(void)singUpUser:(NSString * )firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password  passwordConfirmation:(NSString *)passwordConfirmation memberId:(NSString *)memberID completion:(void (^)(bool status, NSError * error))block failure:(void (^)(bool status, NSError * error))failureBlock{

    APIClient *apiClient = [APIClient sharedAPICLient];
    
    NSDictionary * params = [AuthenticationService paramsForSignUp:firstName lastName:lastName email:email password:password passwordConfirmation:passwordConfirmation memberId:memberID];
    
    [apiClient POST:kSignUpURL parameters:params completion:^(id response, NSError *error) {
        if (!error) {
            block(true, nil);
        }else{
            failureBlock(false, error);
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
                       @"auth_token" : [UserServices currentToken]
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
