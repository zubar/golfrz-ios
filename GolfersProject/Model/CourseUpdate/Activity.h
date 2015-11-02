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
@property (copy, nonatomic, readonly) NSNumber * isCommentable;
@property (copy, nonatomic, readonly) NSString *imgPath;
@property (copy, nonatomic, readonly) NSNumber *hasUserCommented;
@property (copy, nonatomic, readonly) NSNumber *commentsCount;
@property (copy, nonatomic, readonly) NSNumber *likesCount;

@property (copy, nonatomic, readonly) NSNumber *hasUserLiked;
@property (copy, nonatomic, readonly) NSNumber *userNotificationId;

@end
