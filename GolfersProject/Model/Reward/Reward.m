//
//  Reward.m
//  GolfersProject
//
//  Created by Zubair on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Reward.h"
#import "Constants.h"

@implementation Reward

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemId" : @"id",
             @"name" : @"name",
             @"rewardDetail" : @"description",
             @"pointsRequired" : @"points",
             @"rewardBreif" : @"short_description",
             @"imagePath" : @"image_path",
             };
}

+ (NSValueTransformer *)imagePathJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id relativePath) {
        return [self imageURLfromRelativeUR:relativePath ];
    }];
}

+ (NSString *)imageURLfromRelativeUR:(NSString *)relativePath {
    return [NSString stringWithFormat:@"%@%@", kBaseImageUrl, relativePath]; // KBaseImageUrl
}
@end
