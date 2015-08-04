//
//  Comment.h
//  GolfersProject
//
//  Created by Zubair on 8/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//
#import <Mantle/Mantle.h>
#import "MTLModel.h"

@class User;
@interface Activity : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber * itemId;
@property (copy, nonatomic, readonly) NSDate * createdAt;
@property (copy, nonatomic, readonly) NSDate * updatedAt;
@property (copy, nonatomic, readonly) NSString * text;
@property (copy, nonatomic, readonly) NSString * title;
@property (copy, nonatomic, readonly) NSNumber * courseId;
@property (copy, nonatomic, readonly) NSNumber * commentCount;

@end
