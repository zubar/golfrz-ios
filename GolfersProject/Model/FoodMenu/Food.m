//
//  Food.m
//  GolfersProject
//
//  Created by Zubair on 6/9/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Food.h"
#import "SideItem.h"

@implementation Food

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"foodId" : @"id",
             @"name" : @"name",
             @"price" : @"price",
             @"imageUrl" : @"image_url"
//             @"details" : @"description",
//             @"sideItems" : @"menu_side_items"
             //propertyName : json_key
             };
}
+ (NSValueTransformer *)sideItemsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SideItem class]];
}

@end
