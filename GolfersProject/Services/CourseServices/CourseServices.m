//
//  CourseServices.m
//  GolfersProject
//
//  Created by Zubair on 5/20/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "CourseServices.h"
#import "Course.h"
#import "UserServices.h"

#import "APIClient.h"
#import "Constants.h"
#import <Overcoat/OVCResponse.h>
#import "GolfrzError.h"
#import "FeaturedControl.h"

@implementation CourseServices

static Course * currentCourse = nil;


+(void)courseDetailInfo:(void (^)(bool status, Course * currentCourse))successBlock failure:(void (^)(bool status, GolfrzError * error))failureBlock{
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    
    [apiClient GET:kCourseDetail parameters:[self paramsCourseDetailInfo] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            Course * mCourse = [resp result];
            [self setCurrentCourse:mCourse];
            successBlock(true, mCourse);
        }else
            failureBlock(false, [resp result]);
    }];
    
}


+(void)courseInfo:(void (^)(bool, id tObject))successBlock failure:(void (^)(bool, NSError *))failureBlock{
    
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    [apiClient GET:kCourseInfo parameters:[CourseServices paramsCourseInfo] success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            successBlock(true, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error) {
            failureBlock(false, error);
        }
    }];
}

+(void)checkInToCurrentCourse:(void(^)(bool status, id responseObject))successBlock failure:(void (^)(bool, NSError *))failureBlock{

    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kCheckInUrl parameters:[CourseServices paramsCourseDetailInfo] success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];

}

+(void)setCurrentCourse:(Course *)mCourse{
    currentCourse = nil;
    currentCourse = mCourse;
}

+(Course *)currentCourse{
    return currentCourse;
}

+(void)getEnabledFeatures:(void(^)(bool status, NSArray * enabledFeatures))successBlock
                  failure:(void(^)(bool status, GolfrzError * error))failureBlock
{

}
#pragma mark - Helper Methods

+(NSDictionary *)paramsCourseDetailInfo{
        return @{
                @"app_bundle_id": kAppBundleId,
                @"user_agent" : kUserAgent,
                @"auth_token" : [UserServices currentToken]
    };
}



+(NSDictionary *)paramsCourseInfo{
    return @{
             @"app_bundle_id": kAppBundleId,
             @"user_agent" : kUserAgent
             };
}
@end
