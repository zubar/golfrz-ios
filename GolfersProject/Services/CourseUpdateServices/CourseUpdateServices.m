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
#import "UtilityServices.h"
@implementation CourseUpdateServices


+(void)getCourseUpdates:(void(^)(bool status, CourseUpdate * update))successBlock
                failure:(void(^)(bool status, GolfrzError * error))failureBlock
{
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kCourseUpdatesList parameters:[CourseUpdateServices paramCourseUpdates]
        completion:^(id response, NSError *error) {
            if(!error) successBlock(true, [response result]);
            else failureBlock(false, [response result]);
    }];
}

+(void)getCommentsOnPostId:(NSNumber *)postId
                   success:(void(^)(bool status, Post * mPost))successBlock
                   failure:(void(^)(bool status, GolfrzError * error))failureBlock
{

    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kGetDetailCommentsOnThread parameters:[CourseUpdateServices paramPostId:postId]
        completion:^(id response, NSError *error) {
            if(!error) successBlock(true, [response result]);
            else failureBlock(false, [response result]);
    }];
}

+(void)postComment:(NSString *)comment
          onPostId:(NSNumber *)postId
           success:(void(^)(bool status, id successMessage))successBlock
           failure:(void(^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient POST:KPostComment parameters:[CourseUpdateServices paramAddComment:comment postId:postId] completion:^(id response, NSError *error) {
        if(!error) successBlock(true, [response result]);
        else failureBlock(false, [response result]);
    }];
}

+(void)addKudos:(NSNumber *)postId
           success:(void(^)(bool status, id successMessage))successBlock
           failure:(void(^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient POST:KAddKudos parameters:[CourseUpdateServices paramAddKudos:postId] completion:^(id response, NSError *error) {
        if(!error) successBlock(true, [response result]);
        else failureBlock(false, [response result]);
    }];
}





#pragma mark - HelperMethods
+(NSDictionary *)paramCourseUpdates
{
    return [UtilityServices authenticationParams];
}

+(NSDictionary *)paramPostId:(NSNumber *)postId{
    NSDictionary * param =@{
             @"notification_id" : postId
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}
+(NSDictionary *)paramAddComment:(NSString *)comment postId:(NSNumber *)postId{
   
    NSDictionary * param = @{
             @"notification_id" : postId,
             @"comment" : comment
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}

+(NSDictionary *)paramAddKudos:(NSNumber *)postId{
    
    NSDictionary *param = @{
             @"notification_id" : postId,
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}



@end