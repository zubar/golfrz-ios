//
//  GreenCoordinate.m
//  GolfersProject
//
//  Created by Zubair on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "GreenCoordinate.h"

@implementation GreenCoordinate

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"latitude" : @"latitude",
             @"longitude" : @"longitude",
             @"type": @"location_type",
             //propertyName : json_key
             };
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id typeName) {
        return [self macroForGreenCord:typeName];
    }];
}

+ (NSString *)macroForGreenCord:(NSString *)greenType {
    
    if([greenType isEqualToString:@"green_front"])
        return GREEN_FRONT;
    else
    if ([greenType isEqualToString:@"green_mid"])
        return GREEN_MIDDLE;
    else
    if([greenType isEqualToString:@"green_back"])
        return GREEN_BACK;
    else
        return GREEN_UNDEFINED;
}

@end