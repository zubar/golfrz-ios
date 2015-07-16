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
             @"type": @"type",
             //propertyName : json_key
             };
}

@end