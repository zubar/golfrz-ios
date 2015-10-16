//
//  Course.m
//  GolfersProject
//
//  Created by Zubair on 5/20/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Course.h"
#import "Coordinate.h"
#import "StaffMember.h"
#import "Department.h"
#import "Constants.h"

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
             @"coordinates" : @"course_location",
             @"postalCode" : @"course_postal_code",
             @"departments" : @"course_departments",
             @"staff" : @"course_staff",
             @"notificationCount" : @"notification_count"
             //propertyName : json_key
             };
}

+ (NSValueTransformer *)coordinatesJSONTransformer {
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Coordinate class]];
        //return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Coordinates class]];
}

+ (NSValueTransformer *)staffJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StaffMember class]];
}

+ (NSValueTransformer *)departmentsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Department class]];
}


// Making image path absolute URL:
+ (NSValueTransformer *)courseLogoJSONTransformer {
    
  return [MTLValueTransformer transformerWithBlock:^id(id relativePath) {
        return [self absoluteImageURLfromRelativeUR:relativePath ];
    }];
}

+ (NSValueTransformer *)courseBackgroundImageJSONTransformer {
    
    return [MTLValueTransformer transformerWithBlock:^id(id relativePath) {
        return [self absoluteImageURLfromRelativeUR:relativePath ];
    }];
}

+ (NSString *)absoluteImageURLfromRelativeUR:(NSString *)relativePath {
    
    return [NSString stringWithFormat:@"%@%@", kBaseImageUrl, relativePath]; // KBaseImageUrl
}

@end


