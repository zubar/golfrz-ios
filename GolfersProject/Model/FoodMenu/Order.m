//
//  Order.m
//  GolfersProject
//
//  Created by Zubair on 6/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Order.h"

@implementation Order

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"orderId" : @"order_id",
             @"name" : @"name",
             @"price" : @"price",
             @"quantity" : @"quantity",
             @"details" : @"description",
             @"imageUrl" : @"menu_image_path"
             //propertyName : json_key
             };
}

@end
