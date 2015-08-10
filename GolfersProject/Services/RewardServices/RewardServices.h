//
//  RewardServices.h
//  GolfersProject
//
//  Created by Zubair on 8/5/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GolfrzError;
@class Reward;

@interface RewardServices : NSObject



+(void)getRewardsList:(void(^)(bool status, NSArray * rewardList))successBlock
              failure:(void(^)(bool status, GolfrzError * error))failureBlcok;

+(void)getRewardDetailWithId:(NSNumber *)rewardId
                     success:(void(^)(bool status, Reward * mReward))successBlock
                     failure:(void(^)(bool status, GolfrzError * error))failureBlock;

+(void)redeemRewardWithId:(NSNumber *)rewardId
                  success:(void(^)(bool status, id response))successBlock
                  failure:(void(^)(bool status, GolfrzError * error))failureBlock;

+(void)getUserRewardPoints:(void(^)(bool status, id response))successBlock
                   failure:(void(^)(bool status, GolfrzError * error))failureBlock;

@end
