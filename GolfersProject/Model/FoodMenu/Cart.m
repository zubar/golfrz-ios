//
//  OrderList.m
//  GolfersProject
//
//  Created by Zubair on 6/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Cart.h"
#import "Order.h"

@implementation Cart

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"orders" : @"order_list",
             //propertyName : json_key
             };
}
+ (NSValueTransformer *)ordersJSONTransformer {
    // return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[SideItem class]];
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Order class]];
}


@end
