//
//  StaffType.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "StaffType.h"

@implementation StaffType


+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemId" : @"id",
             @"name" : @"name",
            //propertyName : json_key
             };
}

@end
