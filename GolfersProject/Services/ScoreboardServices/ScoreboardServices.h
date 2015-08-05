//
//  ScoreboardServices.h
//  GolfersProject
//
//  Created by Zubair on 7/29/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreboardServices : NSObject

+(void)getScoreForUserId:(NSNumber *)userId
                  holeId:(NSNumber *)holeId
                 roundId:(NSNumber *)roundId
                 success:(void (^)(bool status, id roundId))successBlock
                 failure:(void (^)(bool status, NSError * error))failureBlock;


+(void)getScoreCardForRoundId:(NSNumber *)roundId
                    subCourse:(NSNumber *)subCourseId
                      success:(void (^)(bool status, id responseObject))successBlock
                      failure:(void (^)(bool status, NSError * error))failureBlock;
+(void)getTestScoreCard:(void (^)(bool status, id responseObject))successBlock
                failure:(void (^)(bool status, NSError * error))failureBlock;


    @end
