//
//  Round.m
//  GolfersProject
//
//  Created by Zubair on 7/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RoundMetaData.h"
#import "SubCourse.h"
#import "GameType/GameType.h"
#import "ScoreType/ScoreType.h"


@implementation RoundMetaData

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"subCourses" : @"sub_courses",
             @"scoreTypes" : @"score_types",
             @"gameTypes" : @"game_types",
             //propertyName : json_key
             
             @"roundId" : @"id",
             @"name" : @"name",
             @"status" : @"status",
             };
}

+ (NSValueTransformer *)subCoursesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SubCourse class]];
}

+ (NSValueTransformer *)scoreTypesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[ScoreType class]];
}

+ (NSValueTransformer *)gameTypesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[GameType class]];
}

@end

