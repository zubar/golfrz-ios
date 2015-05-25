//
//  Course.m
//  GolfersProject
//
//  Created by Zubair on 5/20/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Course.h"
#import "Coordinates.h"

@implementation Course

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"courseName" : @"course_name",
             @"courseLogo" : @"course_logo",
             @"courseBackgroundImage" : @"course_bg_image",
             @"courseTheme" : @"course_theme",
             @"courseState" : @"course_state",
             @"courseCity"  : @"course_city",
             @"courseAddress" : @"course_address",
             @"coordinates" : @"course_location"
             //propertyName : json_key
             };
}

+ (NSValueTransformer *)coordinatesJSONTransformer {
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Coordinates class]];
        //return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Coordinates class]];
}



@end


