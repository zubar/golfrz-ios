//
//  TeetimeData.m
//  GolfersProject
//
//  Created by Zubair on 7/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "TeetimeData.h"
#import "Teetime.h"

@implementation TeetimeData


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"teetimes" : @"tee_times"
             //propertyName : json_key
             };
}

+ (NSValueTransformer *)teetimesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Teetime class]];
}

@end
