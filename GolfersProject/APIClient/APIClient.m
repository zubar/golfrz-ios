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
#import "Constants.h"
#import "Course.h"


@implementation APIClient

+(APIClient *)sharedAPICLient{
    
    static APIClient *_aPIClient = nil;
    
    static dispatch_once_t onceToken;
    //Use Grand Central Dispatch to create a single instance and do any initial setup only once.
    dispatch_once(&onceToken, ^{
        //These are only invoked the onceToken has never been used before.
        _aPIClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    return _aPIClient;
}

#pragma mark - OVCHTTPSessionManager

+ (Class)errorModelClass {
    return [GolfrzErrorResponse class];
}


+(NSDictionary *)modelClassesByResourcePath{

    return @{
             kSignInURL : [User class],
             kCourseInfo : [Course class]
             };
}

                      
@end
