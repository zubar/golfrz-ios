//
//  PastScore.m
//  GolfersProject
//
//  Created by Zubair on 8/11/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PastScore.h"
#import "NSDate+Helper.h"

@implementation PastScore

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemId" : @"id",
             @"roundId" : @"round_id",
             @"createdAt" : @"created_at",
             @"updatedAt" : @"updated_at",
             @"grossScore" : @"gross_score",
             @"netScore" : @"net_score",
             @"skinCount" : @"skin_count",
             };
}
+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        return [[self.dateFormatter dateFromString:dateString] toLocalTime];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:[date toGlobalTime]];
    }];
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
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


@end
