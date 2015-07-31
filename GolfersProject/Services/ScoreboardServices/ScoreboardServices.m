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
                  failure:(void (^)(bool status, GolfrzError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    NSLog(@"GET-INDIVIDUAL-SCORE:%@", [ScoreboardServices paramsScoreForUserId:userId holeId:holeId roundId:roundId]);
    
    [apiClient GET:kGetIndividualScore parameters:[ScoreboardServices paramsScoreForUserId:userId holeId:holeId roundId:roundId] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber * score = responseObject[@"users_score"];
        successBlock(true, score);
    } failure:^(NSURLSessionDataTask *task, id response) {
        NSLog(@"%@", [response result]);
    }];
}


#pragma mark - Helper Methods

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
