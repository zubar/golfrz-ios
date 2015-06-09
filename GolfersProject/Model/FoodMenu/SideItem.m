//
//  SideItem.m
//  GolfersProject
//
//  Created by Zubair on 6/9/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "SideItem.h"

@implementation SideItem


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemId" : @"id",
             @"name" : @"name",
             @"price" : @"price",
             @"details" : @"description"
             //             @"sideItems" : @"menu_side_items"
             //propertyName : json_key
             };
}
@end

