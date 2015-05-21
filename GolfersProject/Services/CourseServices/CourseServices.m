//
//  CourseServices.m
//  GolfersProject
//
//  Created by Zubair on 5/20/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "CourseServices.h"
#import "Course.h"

#import "APIClient.h"
#import "Constants.h"
#import <Overcoat/OVCResponse.h>

@implementation CourseServices

+(void)courseInfo:(void (^)(bool status, Course * currentCourse))successBlock failure:(void (^)(bool status, NSError * error))failureBlock{
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    
    [apiClient POST:kCourseInfo parameters:[self paramsForCourseInfo] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            Course * mCourse = [resp result];
            successBlock(true, mCourse);
        }else
            failureBlock(false, error);
    }];
    
}


#pragma mark - Helper Methods

+(NSDictionary *)paramsForCourseInfo{
        return @{
                @"app_bundle_id": kAppBundleId,
                @"user_agent" : kUserAgent
    };
}

@end
