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
#import "GolfrzError.h"
#import "UtilityServices.h"



@implementation AuthenticationService


+(void)loginWithUserName:(NSString *)name
                password:(NSString *)password
                 success:(void (^)(bool status, NSDictionary * userInfo))successBlock
                 failure:(void (^)(bool status, NSError *error))failureBlock{

    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kSignInURL parameters:[AuthenticationService paramsForLogin:name password:password] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (responseObject[@"status"]) {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:responseObject[@"token"] forKey:kUSER_TOKEN];
            [defaults setValue:responseObject[@"email"] forKey:kUSER_EMAIL];
            [defaults setValue:responseObject[@"id"] forKey:kUSER_ID];

            NSLog(@"Email: %@, Token: %@, User_Id: %@", responseObject[@"email"], responseObject[@"token"], responseObject[@"id"]);
            [defaults synchronize];
            
            // push manager will receive this notificationa and post the notif to server.
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessful object:nil];
        }
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
    

}


+(void)resetUserPassword:(NSString *)email
              completion:(void (^)(bool status))successfullyPosted
                 failure:(void (^)(bool status, GolfrzError *error))failureBlock{

    APIClient *apiClient = [APIClient sharedAPICLient];
    
    NSDictionary * params = @{
                              @"email":email,
                              @"user_agent" : kUserAgent,
                              @"app_bundle_id" : kAppBundleId,
                              };
    
    [apiClient POST:kForgetPasswordURL parameters:params completion:^(id response, NSError *error) {
        if (!error)
            successfullyPosted(true);
        else{
            if(![UtilityServices checkIsUnAuthorizedError:error])
                failureBlock(false, [response result]);
        }
    }];
}

+(void)signOutUser:(void (^)(bool status))successfullyPosted
      failureBlock:(void (^)(bool status, GolfrzError * error))failureBlock{
  
    APIClient *apiClient = [APIClient sharedAPICLient];
    NSString * signOutUrl = [NSString stringWithFormat:@"%@%@", kSignOutURL, [UserServices currentToken]];
    
    [apiClient DELETE:signOutUrl parameters:nil completion:^(id response, NSError *error) {
        if (!error) {
            successfullyPosted(true);
        }else{
            if(![UtilityServices checkIsUnAuthorizedError:error])
                failureBlock(false, [response result]);
        }
    }];
    
}



+(void)singUpUser:(NSString * )firstName
         lastName:(NSString *)lastName
            email:(NSString *)email
         password:(NSString *)password
passwordConfirmation:(NSString *)passwordConfirmation
         memberId:(NSString *)memberID
         handicap:(NSString *)handicap
       completion:(void (^)(bool status, NSDictionary * userInfo))successBlock
          failure:(void (^)(bool status, GolfrzError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    NSDictionary * params = [AuthenticationService paramsForSignUp:firstName lastName:lastName email:email password:password passwordConfirmation:passwordConfirmation memberId:memberID handicap:handicap];
    
    [apiClient POST:kSignUpURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject){
            if (responseObject[@"status"]) {
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:responseObject[@"token"] forKey:kUSER_TOKEN];
                [defaults setValue:responseObject[@"email"] forKey:kUSER_EMAIL];
                [defaults setValue:responseObject[@"id"] forKey:kUSER_ID];
                //[defaults setValue:responseObject[@"first_name"] forKey:KUSER_NAME];
                NSLog(@"Email: %@, Token: %@, User_Id: %@", responseObject[@"email"], responseObject[@"token"], responseObject[@"id"]);
                [defaults synchronize];
            }
            successBlock(true, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        @try {
            
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = nil;
        if(errorData !=nil ) serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        NSError * parseError = nil;
        GolfrzError * terror = nil;
        
        if (serializedData != nil)
            terror = [MTLJSONAdapter modelOfClass:[GolfrzError class] fromJSONDictionary:serializedData error:&parseError];
        else
            terror = [GolfrzError modelWithDictionary:@{@"errorMessage": @"An unknown Error Occured!"} error:&parseError];
        failureBlock(false, terror);
        }
        @catch (NSException *exception) {
            NSLog(@"exception: %@", exception);
        }
    }];
}
#pragma mark - Helper Methods
+(NSDictionary *)paramsForLogin:(NSString *)userName password:(NSString *)pwd{
    
    return    @{
                @"email": userName,
                @"password": pwd,
                @"app_bundle_id" : kAppBundleId,
                @"user_agent" : kUserAgent,
                };
}

+(NSDictionary *)paramsForSignOut{
    
    return   @{
               @"user_login":@{
                       @"auth_token" : ([UserServices currentToken] != nil ? [UserServices currentToken] : @""),
                       }
               };
}

+(NSDictionary *)paramsForSignUp:(NSString * )firstName
                        lastName:(NSString *)lastName
                           email:(NSString *)email
                        password:(NSString *)password
            passwordConfirmation:(NSString *)passwordConfirmation
                        memberId:(NSString *)memberID
                        handicap:(NSString *)handicap{
    
    
    NSDictionary * dic = @{
                                  @"email": email,
                                  @"password": password,
                                  @"password_confirmation": passwordConfirmation,
                                  @"first_name": firstName,
                                  @"last_name": lastName,
                                  @"user_agent" : kUserAgent,
                                  @"app_bundle_id" : kAppBundleId,
                                  @"handicap" : handicap,
                                  };
    
    
    NSMutableDictionary * mDic = [dic mutableCopy];
    if([[memberID stringByReplacingOccurrencesOfString:@" " withString:@""] length] > 0){
        [mDic setObject:memberID forKey:@"member_id"];
    }
    
    return mDic;
}

@end
