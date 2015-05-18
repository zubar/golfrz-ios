//
//  APIClient.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/18/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "APIClient.h"
#import "User.h"
#import "GolfrzErrorResponse.h"



@implementation APIClient



#pragma mark - OVCHTTPSessionManager

+ (Class)errorModelClass {
    return [GolfrzErrorResponse class];
}


+(NSDictionary *)modelClassesByResourcePath{

    return @{
             @"users/sign_in" : [User class]
             };
}

                      
@end
