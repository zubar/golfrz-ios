//
//  Food.m
//  GolfersProject
//
//  Created by Zubair on 6/9/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "FoodBeverage.h"
#import "SideItem.h"
#import "Constants.h"

@implementation FoodBeverage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"foodId" : @"id",
             @"name" : @"name",
             @"price" : @"price",
             @"imageUrl" : @"image_path",
             @"details" : @"description",
             @"sideItems" : @"menus_side_items"
             //propertyName : json_key
             };
}

+ (NSValueTransformer *)sideItemsJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SideItem class]];
}

+ (NSValueTransformer *)imageUrlJSONTransformer{
    return [MTLValueTransformer transformerWithBlock:^id(id relativePath) {
        return [self absoluteImageURLfromRelativeUR:relativePath ];
    }];
}

+ (NSString *)absoluteImageURLfromRelativeUR:(NSString *)relativePath{
    return [NSString stringWithFormat:@"%@%@", kBaseImageUrl, relativePath];
}
@end
