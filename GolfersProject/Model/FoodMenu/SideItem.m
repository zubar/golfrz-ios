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
             @"itemId" : @"side_item_menu_id",
             @"name" : @"name",
             @"price" : @"price",
             @"details" : @"description"
             //propertyName : json_key
             };
}
@end
