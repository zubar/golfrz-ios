//
//  Coordinates.m
//  GolfersProject
//
//  Created by Zubair on 5/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Coordinates.h"

@implementation Coordinates

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"latitude" : @"latitude",
             @"longitude" : @"longitude"
             //propertyName : json_key
             };
}

@end
