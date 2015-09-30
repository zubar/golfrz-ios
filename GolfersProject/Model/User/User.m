//
//  User.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/29/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "User.h"
#import "Constants.h"

@implementation User


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"memberId" : @"member_id",
             @"userId" : @"id",
             @"email" : @"email",
             @"firstName": @"first_name",
             @"lastName" : @"last_name",
             @"handicap" : @"handicap",
             @"imgPath" : @"profile_photo_url",
             @"phone" : @"phone_no",
             @"userIcon" : @"image_path",
            //propertyName : json_key
             };
}

+ (NSValueTransformer *)imgPathJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id relativePath) {
        return [self absoluteImageURLfromRelativeUR:relativePath ];
    }];
}

+ (NSValueTransformer *)userIconJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id relativePath) {
        return [self absoluteImageURLfromRelativeUR:relativePath ];
    }];
}

+ (NSString *)absoluteImageURLfromRelativeUR:(NSString *)relativePath
{
    return [NSString stringWithFormat:@"%@%@", kBaseImageUrl, relativePath];
}
@end
