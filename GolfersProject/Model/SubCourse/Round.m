//
//  Round.m
//  GolfersProject
//
//  Created by Zubair on 7/23/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Round.h"
#import "SubCourse.h"
#import "ScoreType.h"
#import "GameType.h"

@implementation Round

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"roundData" : @"round",
             //propertyName : json_key
             };
}
+ (NSValueTransformer *)roundDataJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[RoundMetaData class]];
}


@end
