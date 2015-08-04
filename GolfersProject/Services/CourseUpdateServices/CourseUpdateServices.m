//
//  CourseUpdateServices.m
//  GolfersProject
//
//  Created by Zubair on 8/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//
#import "APIClient.h"
#import "UserServices.h"
#import "Constants.h"
#import "CourseUpdateServices.h"
#import "CourseUpdate.h"
#import "GolfrzError.h"
#import "Post.h"

@implementation CourseUpdateServices


+(void)getCourseUpdates:(void(^)(bool status, CourseUpdate * update))successBlock
                failure:(void(^)(bool status, GolfrzError * error))failureBlock{
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kCourseUpdatesList parameters:[CourseUpdateServices paramCourseUpdates]
        completion:^(id response, NSError *error) {
            if(!error) successBlock(true, [response result]);
            else failureBlock(false, [response result]);
    }];
}

+(void)getCommentsOnPostId:(NSNumber *)postId
                   success:(void(^)(bool status, Post * mPost))successBlock
                   failure:(void(^)(bool status, GolfrzError * error))failureBlock{

    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kPostDetailComments parameters:[CourseUpdateServices paramPostId:postId]
        completion:^(id response, NSError *error) {
            if(!error) successBlock(true, [response result]);
            else failureBlock(false, [response result]);
    }];
}

#pragma mark - HelperMethods
+(NSDictionary *)paramCourseUpdates{
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken]
             };
}

+(NSDictionary *)paramPostId:(NSNumber *)postId{
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"notification_id" : postId
             };
}
@end