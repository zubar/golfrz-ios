//
//  RoundPlayers.m
//  GolfersProject
//
//  Created by Zubair on 7/23/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RoundPlayers.h"
#import "User.h"

@implementation RoundPlayers


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"players" : @"players"
             //propertyName : json_key
             };
}

+ (NSValueTransformer *)playersJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[User class]];
}

@end
