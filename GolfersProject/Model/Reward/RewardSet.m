//
//  RewardSet.m
//  GolfersProject
//
//  Created by Zubair on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RewardSet.h"
#import "Reward.h"

@implementation RewardSet

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"rewards" : @"rewards"
             };
}

+ (NSValueTransformer *)rewardsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Reward class]];
}
@end
