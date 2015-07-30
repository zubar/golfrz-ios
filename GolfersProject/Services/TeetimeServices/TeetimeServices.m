//
//  TeetimeServices.m
//  GolfersProject
//
//  Created by Zubair on 7/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "TeetimeServices.h"
#import "Constants.h"
#import "UserServices.h"
#import "SubCourse.h"
#import "GameSettings.h"
#import "APIClient.h"
#import "GolfrzError.h"
#import "Utilities.h"
#import <Overcoat/Overcoat.h>
#import "TeetimeData.h"
#import "Teetime.h"

@implementation TeetimeServices


+(void)getTeetimesForSubcourse:(NSNumber *)subcourseId
                       success:(void(^)(bool status, TeetimeData * dataTees ))successBlock
                       failure:(void (^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kGetteetimes parameters:[TeetimeServices paramsGetTeetimesForSubcourse:subcourseId] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            successBlock(true, [resp result]);
        }else{
            failureBlock(false, [resp result]);
        }
    }];
}

#pragma mark - HelperMethods
+(NSDictionary *)paramsGetTeetimesForSubcourse:(NSNumber *)subcourseId{
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"sub_course_id" : subcourseId,
             };
    
}

@end
