//
//  Shot.m
//  GolfersProject
//
//  Created by Zubair on 8/16/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Shot.h"

@implementation Shot

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemId" : @"id",
             @"holeId" : @"hole_id",
             @"userId" : @"user_id",
             @"roundId" : @"round_id",
             @"shotType" : @"shot_type",
            };
}
@end
