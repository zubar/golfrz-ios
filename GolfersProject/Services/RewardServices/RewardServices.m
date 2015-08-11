//
//  RewardServices.m
//  GolfersProject
//
//  Created by Zubair on 8/5/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RewardServices.h"
#import "CourseServices.h"
#import "User.h"
#import "UserServices.h"
#import "Constants.h"
#import "GolfrzError.h"
#import "Reward.h"
#import "APIClient.h"
#import "RewardSet.h"

@implementation RewardServices

#pragma mark - HelperMethods


+(void)getRewardsList:(void(^)(bool status, NSArray * rewardList))successBlock
              failure:(void(^)(bool status, GolfrzError * error))failureBlcok
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kRewardsList parameters:[RewardServices paramUserAuth] completion:^(id response, NSError *error) {
        if(!error){
            RewardSet * rewardSet = [response result];
            successBlock(true, [rewardSet rewards]);
        }
        else failureBlcok(false, [response result]);
    }];
}

+(void)getRewardDetailWithId:(NSNumber *)rewardId
                     success:(void(^)(bool status, Reward * mReward))successBlock
                     failure:(void(^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kRewardDetail parameters:[RewardServices paramRewardIdentity:rewardId] completion:^(id response, NSError *error) {
        if(!error) successBlock(true, [response result]);
        else failureBlock(false, [response result]);
    }];
    
}

+(void)redeemRewardWithId:(NSNumber *)rewardId
                  success:(void(^)(bool status, id response))successBlock
                  failure:(void(^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient POST:kRewardRedeem parameters:[RewardServices paramRewardIdentity:rewardId] completion:^(id response, NSError *error) {
        if(!error) successBlock(true, [response result]);
        else failureBlock(false, [response result]);
    }];
}

+(void)getUserRewardPoints:(void(^)(bool status, NSNumber * totalPoints))successBlock
                   failure:(void(^)(bool status, GolfrzError * error))failureBlock
{
//TODO: 
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient GET:kRewardUserTotalPoints parameters:[RewardServices paramUserAuth] success:^(NSURLSessionDataTask *task, id responseObject) {
        if([responseObject objectForKey:@"points"] != [NSNull null])
              successBlock(true,[responseObject objectForKey:@"points"] );
        else
            successBlock(true, [NSNumber numberWithInt:0]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        GolfrzError * golfrError = [GolfrzError modelWithDictionary:@{@"errorMessage":@"Can not get your reward points due to an error."} error:nil];
        failureBlock(false, golfrError);
    }];
}
/**
 @abstract Method to create params form getting reward detail
 @return NSDictionary, dictionary contains all required params to call the api. 
 @param rewardId: id of the reward whose details are to fetch.
 */
+(NSDictionary *)paramRewardIdentity:(NSNumber *)rewardId{
    
    return @{
             @"reward_id" : rewardId,
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             };
}

+(NSDictionary *)paramUserAuth{
    return @{
        @"app_bundle_id" : kAppBundleId,
        @"user_agent" : kUserAgent,
        @"auth_token" : [UserServices currentToken],
    };
}

@end
