//
//  RoundDataServices.h
//  GolfersProject
//
//  Created by Zubair on 7/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoundData.h"

@interface RoundDataServices : NSObject

/*
 */
+(void)getRoundData:(void (^)(bool status, RoundData * subCourse))successBlock
            failure:(void (^)(bool status, NSError * error))failureBlock;


+(void)getNewRoundIdWithOptions:(NSDictionary *)options
                        success:(void (^)(bool status, NSNumber * roundId))successBlock
                        failure:(void (^)(bool status, NSError * error))failureBlock;

+(void)startNewRoundWithOptions:(NSDictionary *)roundOptions
                        success:(void (^)(bool status, id roundId))successBlock
                        failure:(void (^)(bool status, NSError * error))failureBlock;

+(void)finishRoundWithBlock:(void(^)(bool status, id response))successBlock
                    failure:(void(^)(bool status, NSError * error))failureBlock;

+(void)addGuestWithEmail:(NSString *)email
               firstName:(NSString *)fName
                lastName:(NSString *)lName
                 success:(void(^)(bool status, NSDictionary * response))successBlock
                 failure:(void(^)(bool status, NSError * error))failureBlock;

+(void)addShotRoundId:(NSNumber *)round
                holeId:(NSNumber *)holeId
              shotType:(NSString *)shotType
               success:(void(^)(bool, id))successBlock
               failure:(void(^)(bool, id))failureBlock;


+(void)deleteShotWithShotId:(NSNumber *)shotId
                    success:(void(^)(bool, id))successBlock
                    failure:(void(^)(bool, id))failureBlock;

+(void)addDirectScore:(NSNumber *)score
               holeId:(NSNumber *)holeId
              success:(void(^)(bool status, NSDictionary * response))successBlock
              failure:(void(^)(bool status, NSError * error))failureBlock;


+(void)deleteShotRoundId:(NSNumber *)round
                  holeId:(NSNumber *)holeId
                shotType:(NSString *)shotType
                  shotId:(NSNumber *)shotId
                 success:(void(^)(bool, id))successBlock
                 failure:(void(^)(bool, id))failureBlock;


@end
