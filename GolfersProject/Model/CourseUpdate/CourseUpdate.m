//
//  CourseUpdate.m
//  GolfersProject
//
//  Created by Zubair on 8/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//
#import "Activity.h"
#import "CourseUpdate.h"

@implementation CourseUpdate

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"activities" : @"notification_list"
             //propertyName : json_key
             };
}

+ (NSValueTransformer *)activitiesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Activity class]];
}

@end
