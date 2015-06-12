//
//  Departments.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Department.h"

@implementation Department


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"departmentId" : @"id",
             @"name" : @"name",
             @"startTime" : @"start_at",
             @"endTime" : @"end_at",
             @"phone" : @"phone"
             //propertyName : json_key
             };
}


+ (NSValueTransformer *)startTimeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)endTimeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}


+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    return dateFormatter;
}

@end
