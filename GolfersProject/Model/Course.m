//
//  Course.m
//  GolfersProject
//
//  Created by Zubair on 5/20/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Course.h"

@implementation Course

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"courseName" : @"course_name",
             @"courseLogo" : @"course_logo",
             @"courseBackgroundImage" : @"course_bg_image",
             @"courseTheme" : @"course_theme",
             @"courseState" : @"course_state",
             @"courseCity"  : @"course_city",
             @"courseAddress" : @"course_address"
             //propertyName : json_key
             };
}

@end


