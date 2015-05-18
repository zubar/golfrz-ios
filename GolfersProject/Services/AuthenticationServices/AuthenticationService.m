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
#import <Overcoat/NSError+OVCResponse.h>
#import <Overcoat/OVCResponse.h>

#import "User.h"

static NSString * const kBaseURL = @"https://powerful-plains-9156.herokuapp.com/api/users/";


@implementation AuthenticationService

+(void)loginWithUserName:(NSString *)name password:(NSString *)password{

//Create our client
APIClient *apiClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
//TODO: Write completion block here.
    NSDictionary * credentials = @{
                                   @"email": @"admin@golfrz.com",
                                   @"password": @"password"
                            };
    
    NSDictionary * params = @{
                              @"user_login" : credentials
                              };
    
    
    [apiClient POST:@"sign_in" parameters:params completion:^(id response, NSError *error) {
        
        OVCResponse * resp = response;
                
        NSLog(@"%@",  [resp result]);
    }];
}



//TODO: Create password reset, sign out method calls same way.


@end
