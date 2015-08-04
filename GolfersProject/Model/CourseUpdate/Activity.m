//
//  Comment.m
//  GolfersProject
//
//  Created by Zubair on 8/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "NSDate+Helper.h"
#import "Activity.h"

@implementation Activity


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemId" : @"id",
             @"createdAt" : @"created_at",
             @"updatedAt" : @"updated_at",
             @"text" : @"text",
             @"title" : @"title",
             @"courseId" : @"course_id",
             @"commentCount" : @"comment_count",
             @"isCommentable" : @"is_commentable",
             //propertyName : json_key
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
