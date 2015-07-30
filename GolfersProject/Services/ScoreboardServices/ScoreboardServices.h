//
//  ScoreboardServices.h
//  GolfersProject
//
//  Created by Zubair on 7/29/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GolfrzError.h"

@interface ScoreboardServices : NSObject

+(void)getScoreForUserId:(NSNumber *)userId
                  holeId:(NSNumber *)holeId
                 roundId:(NSNumber *)roundId
                 success:(void (^)(bool status, id roundId))successBlock
                 failure:(void (^)(bool status, GolfrzError * error))failureBlock;
@end
