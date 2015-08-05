//
//  ScoreboardServices.m
//  GolfersProject
//
//  Created by Zubair on 7/29/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreboardServices.h"
#import "APIClient.h"
#import "Constants.h"
#import "UserServices.h"


@implementation ScoreboardServices

+(void)getScoreForUserId:(NSNumber *)userId
                  holeId:(NSNumber *)holeId
                 roundId:(NSNumber *)roundId
                 success:(void (^)(bool status, id roundId))successBlock
                  failure:(void (^)(bool status, NSError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    NSLog(@"GET-INDIVIDUAL-SCORE:%@", [ScoreboardServices paramsScoreForUserId:userId holeId:holeId roundId:roundId]);
    
    [apiClient GET:kGetIndividualScore parameters:[ScoreboardServices paramsScoreForUserId:userId holeId:holeId roundId:roundId] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber * score = responseObject[@"users_score"];
        successBlock(true, score);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

+(void)getScoreCardForRoundId:(NSNumber *)roundId
                    subCourse:(NSNumber *)subCourseId
                      success:(void (^)(bool status, id responseObject))successBlock
                      failure:(void (^)(bool status, NSError * error))failureBlock{
    
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    [apiClient GET:kGetScoreCard parameters:[ScoreboardServices paramsScoreForSubCourseId:subCourseId roundId:roundId] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        successBlock(true,responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failureBlock(false,error);
        
    }];
}


+(void)getTestScoreCard:(void (^)(bool status, id responseObject))successBlock
            failure:(void (^)(bool status, NSError * error))failureBlock{
    
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] init];
    
    [apiClient GET:@"https://api.myjson.com/bins/23s9m" parameters:[ScoreboardServices paramsScoreForSubCourseId:[NSNumber numberWithInt:1] roundId:[NSNumber numberWithInt:466]] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        successBlock(true,responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failureBlock(false,error);
        
    }];
}

////https://api.myjson.com/bins/2ncny
//+(void)getTestScoreBoard

#pragma mark - Helper Methods

+(NSDictionary *)paramsScoreForSubCourseId:(NSNumber *)subCourseId roundId:(NSNumber *)roundId{

    
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"round_id" : roundId,
             @"sub_course_id":subCourseId
             };
}


+(NSDictionary *)paramsScoreForUserId:(NSNumber *)userId holeId:(NSNumber *)holeId roundId:(NSNumber *)roundId{

    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"hole_id" : holeId,
             @"round_id" : roundId,
             @"user_id" : userId,
             };

}
@end
