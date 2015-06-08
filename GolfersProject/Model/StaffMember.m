//
//  Staff.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "StaffMember.h"
#import "StaffType.h"
@implementation StaffMember


+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"staffId" : @"id",
             @"name" : @"name",
             @"staffTypeId" : @"staff_type_id",
             @"email" : @"email",
             @"imageUrl" : @"photo",
             @"phone" : @"phone",
             @"type" : @"type"
             //propertyName : json_key
             };
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[StaffType class]];
}

@end
