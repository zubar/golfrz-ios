//
//  GameType.m
//  GolfersProject
//
//  Created by Zubair on 7/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "GameType.h"

@implementation GameType

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"gameTypeId" : @"id",
             @"name" : @"name",
             //propertyName : json_key
             };
}

@end
