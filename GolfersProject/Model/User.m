//
//  User.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/18/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "User.h"

@implementation User


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"authToken" : @"auth_token",
             @"email" : @"email",
             @"success" : @"success",
             @"memberId" : @"id",
             @"firstName" : @"first_name"
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
