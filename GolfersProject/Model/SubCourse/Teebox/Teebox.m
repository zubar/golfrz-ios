//
//  Teebox.m
//  GolfersProject
//
//  Created by Zubair on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Teebox.h"

@implementation Teebox

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"teeboxId" : @"id",
             @"name" : @"name",
             @"handicap": @"handicap",
             @"holeId" : @"hole_id",
             //propertyName : json_key
             };
}
@end

