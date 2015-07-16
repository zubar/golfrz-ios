//
//  SubCourseServices.m
//  GolfersProject
//
//  Created by Zubair on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "SubCourseServices.h"
#import "SubCourse.h"
#import "APIClient.h"
#import "Constants.h"
#import "UtilityServices.h"

@implementation SubCourseServices


//+(void)getSubCourseDetail:(void (^)(bool status, SubCourse * subCourse))successBlock
//                  failure:(void (^)(bool status, NSError * error))failureBlock{
//    
//    APIClient * apiClient = [APIClient sharedAPICLient];
//    
//    [apiClient GET:kSubCourses parameters:[UtilityServices authenticationParams] completion:^(id response, NSError *error) {
//        OVCResponse * resp = response;
//        if (!error) {
//            SubCourse * mCourse = [resp result];
//            successBlock(true, mCourse);
//        }else
//            failureBlock(false, error);
//    }];
//    
//}

@end
