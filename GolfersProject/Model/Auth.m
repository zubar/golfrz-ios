//
//  User.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/18/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Auth.h"

@implementation Auth


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"authToken" : @"token",
             @"email" : @"email",
             @"status" : @"status",
             @"memberId" : @"id"
             //propertyName : json_key
             };
}

// Don't delete it for now we will be needing it later.

/*
+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *stringValue) {
        return [NSDateFormatter dateFromTwitterString:stringValue];
    }];
}


+ (NSValueTransformer *)retweetedStatusJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Tweet class]];
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[TwitterUser class]];
}
*/
 
@end
