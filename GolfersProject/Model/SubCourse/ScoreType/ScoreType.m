//
//  ScoreType.m
//  GolfersProject
//
//  Created by Zubair on 7/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreType.h"

@implementation ScoreType

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"scoreTypeId" : @"id",
             @"scoreType" : @"score_type",
             //propertyName : json_key
             };
}

@end
