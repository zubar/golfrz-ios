//
//  Teetime.m
//  GolfersProject
//
//  Created by Zubair on 7/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Teetime.h"
#import "NSDate+Helper.h"

@implementation Teetime

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemId" : @"id",
             @"count" : @"count",
             @"bookedTime" : @"booked_at",
             @"subCourseId" : @"sub_course_id",
             @"updatedTime" : @"updated_at",
             @"userId" : @"user_id",
             @"userName" : @"name",
             @"userEmail" : @"email",
             @"userPhone" : @"phone",
             //propertyName : json_key
             };
}

+ (NSValueTransformer *)bookedTimeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        return [[self.dateFormatter dateFromString:dateString] toLocalTime];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:[date toGlobalTime]];
    }];
}
+ (NSValueTransformer *)updatedTimeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        return [[self.dateFormatter dateFromString:dateString] toLocalTime];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:[date toGlobalTime]];
    }];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    return dateFormatter;
}

- (NSComparisonResult)compare:(Teetime *)otherTeetime{
    return [self.bookedTime compare:otherTeetime.bookedTime];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToTeetime:other];
}

- (BOOL)isEqualToTeetime:(Teetime *)teetime {
    if (self == teetime){
        NSLog(@"Comparitng ---- :%@  with %@ -- NOT EQUAL", [self bookedTime], [teetime bookedTime]);
        return YES;
    }
    if (![[[self bookedTime] toLocalTime] isEqual:[[teetime bookedTime] toLocalTime]]){
        NSLog(@"Comparitng ---- :%@  with %@ -- NOT EQUAL", [[self bookedTime] toLocalTime], [[teetime bookedTime] toLocalTime]);
        return NO;
    }
    NSLog(@"Comparitng ---- :%@  with %@ -- EQUAL", [self bookedTime], [teetime bookedTime]);
    return YES;
}


@end
