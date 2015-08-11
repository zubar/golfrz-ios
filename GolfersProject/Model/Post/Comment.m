//
//  Comment.m
//  GolfersProject
//
//  Created by Zubair on 8/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//
#import "NSDate+Helper.h"
#import "User.h"
#import "Comment.h"

@implementation Comment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"comment" : @"comment",
             @"createdAt" : @"created_at",
             @"notificationId" : @"notification_id",
             @"user" : @"user",
             @"userId" : @"user_id",
             @"itemId" : @"id",
             //propertyName : json_key
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[User class]];
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
