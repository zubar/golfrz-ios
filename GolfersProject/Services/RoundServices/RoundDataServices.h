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

+(void)getRoundData:(void (^)(bool status, RoundData * subCourse))successBlock
                  failure:(void (^)(bool status, NSError * error))failureBlock;

+(void)getNewRoundIdWithOptions:(NSDictionary *)options
                        success:(void (^)(bool status, NSNumber * roundId))successBlock
                        failure:(void (^)(bool status, NSError * error))failureBlock;




@end
