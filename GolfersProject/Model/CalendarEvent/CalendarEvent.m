//
//  CalendarEvent.m
//  GolfersProject
//
//  Created by Zubair on 5/26/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "CalendarEvent.h"

@implementation CalendarEvent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"eventId" : @"id",
             @"dateStart" : @"start_date",
             @"dateEnd": @"end_date",
             @"courseId" : @"course_id",
             @"breif" : @"description",
             @"name" : @"name",
             @"eventType" : @"event_type",
             @"summary" : @"summary",
             @"location" : @"location",
             //propertyName : json_key
             };
}


+ (NSValueTransformer *)dateStartJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)dateEndJSONTransformer {
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
