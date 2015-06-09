//
//  FoodMenu.m
//  GolfersProject
//
//  Created by Zubair on 6/9/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Menu.h"
#import "Food.h"
#import "Beverage.h"

@implementation Menu


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"foodItems" : @"food",
             @"beverageItems" : @"beverage"
             //propertyName : json_key
             };
}
+ (NSValueTransformer *)foodItemsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Food class]];
}
+ (NSValueTransformer *)beverageItemsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Beverage class]];
}

@end
