//
//  Beverage.m
//  GolfersProject
//
//  Created by Zubair on 6/9/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Beverage.h"

@implementation Beverage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"foodId" : @"id",
             @"name" : @"name",
             @"price" : @"price",
             @"imageUrl" : @"image_path",
             @"details" : @"description",
             //propertyName : json_key
             };
}

@end
