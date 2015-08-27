//
//  Hole.m
//  GolfersProject
//
//  Created by Zubair on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Hole.h"
#import "Teebox.h"
#import "GreenCoordinate.h"
#import "Constants.h"

@implementation Hole

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemId" : @"id",
             @"par" : @"par",
             @"holeNumber": @"number",
             @"yards" : @"yards",
             @"teeboxes" : @"tee_boxes",
             @"greenCoordinates" : @"locations",
             @"flyOverVideoPath" : @"fly_over_path",
             @"imagePath" : @"image_path",
             //propertyName : json_key
             };
}

+ (NSValueTransformer *)teeboxesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Teebox class]];
}

+ (NSValueTransformer *)greenCoordinatesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[GreenCoordinate class]];
}


+ (NSValueTransformer *)imagePathJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id relativePath) {
        return [self absoluteImageURLfromRelativeUR:relativePath ];
    }];
}

+ (NSValueTransformer *)flyOverVideoPathJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id relativePath) {
        return [self absoluteImageURLfromRelativeUR:relativePath ];
    }];
}
+ (NSString *)absoluteImageURLfromRelativeUR:(NSString *)relativePath
{
    return [NSString stringWithFormat:@"%@%@", kBaseImageUrl, relativePath]; // KBaseImageUrl
}


@end
