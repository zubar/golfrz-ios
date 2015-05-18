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



@implementation AuthenticationService

+(void)loginWithUserName:(NSString *)name password:(NSString *)password success:(void (^)(User *))success{

//Create our client
APIClient *apiClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
//TODO: Write completion block here.
    
    [apiClient POST:@"users/sign_in" parameters:[AuthenticationService paramsForLogin:name password:password] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            User * mUser =[resp result];
            success(mUser);
        }
    }];
}



//TODO: Create password reset, sign out method calls same way.



#pragma mark - Helper Methods
+(NSDictionary *)paramsForLogin:(NSString *)userName password:(NSString *)pwd{

    NSDictionary * credentials = @{
                                   @"email": userName,
                                   @"password": pwd
                                   };
    NSDictionary * params = @{
                              @"user_login" : credentials
                              };
    return params;
}


@end
