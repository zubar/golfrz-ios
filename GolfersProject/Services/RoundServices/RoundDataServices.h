//
//  RoundDataServices.h
//  GolfersProject
//
//  Created by Zubair on 7/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoundMetaData.h"
@class Round;
@class RoundPlayers;
@class GolfrzError;

typedef NS_ENUM(NSInteger, ShotType) {
    ShotTypePenalty= 0,
    ShotTypeStardard,
    ShotTypePutt,
};


@interface RoundDataServices : NSObject

/*
 */


+(void)getRoundData:(void (^)(bool status, RoundMetaData * subCourse))successBlock
            failure:(void (^)(bool status, GolfrzError * error))failureBlock;


+(void)getNewRoundIdWithOptions:(NSDictionary *)options
                        success:(void (^)(bool status, NSNumber * roundId))successBlock
                        failure:(void (^)(bool status, NSError * error))failureBlock;


+(void)startNewRoundWithId:(NSNumber *)roundId
               subCourseId:(NSNumber *)subcourseId
                   success:(void (^)(bool status, id roundId))successBlock
                   failure:(void (^)(bool status, NSError * error))failureBlock;

+(void)finishRoundWithBlock:(void(^)(bool status, id response))successBlock
                    failure:(void(^)(bool status, NSError * error))failureBlock;


+(void)addGuestWithEmail:(NSString *)email
               firstName:(NSString *)fName
                lastName:(NSString *)lName
                handicap:(NSNumber *)handicap
                teeBoxId:(NSNumber *)teeBoxId
                 success:(void(^)(bool status, NSDictionary * response))successBlock
                 failure:(void(^)(bool status, NSError * error))failureBlock;

+(void)addShotRoundId:(NSNumber *)round
               holeId:(NSNumber *)holeId
             shotType:(ShotType )shotType
              success:(void(^)(bool, id response))successBlock
              failure:(void(^)(bool,  NSError *error))failureBlock;


+(void)deleteShotWithShotId:(NSNumber *)shotId
                    success:(void(^)(bool, id response))successBlock
                    failure:(void(^)(bool,  NSError *error))failureBlock;


+(void)deleteShotRoundId:(NSNumber *)round
                  holeId:(NSNumber *)holeId
                shotType:(ShotType )shotType
                  shotId:(NSNumber *)shotId
                 success:(void(^)(bool, id response))successBlock
                 failure:(void(^)(bool, NSError * error))failureBlock;
    

+(void)addDirectScore:(NSNumber *)score
               holeId:(NSNumber *)holeId
             playerId:(NSNumber *)playerId
              success:(void(^)(bool status, NSDictionary * response))successBlock
              failure:(void(^)(bool status, NSError * error))failureBlock;


+(void)updateRound:(void(^)(bool status, id response))successBlock
           failure:(void(^)(bool status, NSError * error))failureBlock;
    

+(void)getPlayersInRoundId:(NSNumber *)roundId
                   success:(void(^)(bool, RoundPlayers * players))successBlock
                   failure:(void(^)(bool, GolfrzError * error))failureBlock;

+(void)getRoundInfoForRoundId:(NSNumber *)roundId
                      success:(void(^)(bool status, Round * round))successBlock
                      failure:(void(^)(bool status, GolfrzError * error))failureBlock;


+(void)isRoundInProgress:(void(^)(bool status, NSNumber * roundNo, NSNumber * subCourseId))successBlock
                 failure:(void(^)(bool status, GolfrzError * error))failureBlock;
@end
