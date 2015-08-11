//
//  Post.m
//  GolfersProject
//
//  Created by Zubair on 8/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//
#import "Comment.h"
#import "Post.h"

@implementation Post
+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"comments" : @"notification_comments"
             };
}

+ (NSValueTransformer *)commentsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Comment class]];
}
@end
