//
//  SubCourse.m
//  GolfersProject
//
//  Created by Zubair on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "SubCourse.h"
#import "Hole/Hole.h"

@implementation SubCourse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemId" : @"id",
             @"name" : @"name",
             @"holes": @"holes",
             //propertyName : json_key
             };
}

+ (NSValueTransformer *)holesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Hole class]];
}

@end

