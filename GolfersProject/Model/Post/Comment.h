//
//  Comment.h
//  GolfersProject
//
//  Created by Zubair on 8/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "MTLModel.h"
#import <JSQMessagesViewController/JSQMessages.h>

@class User;
@interface Comment : MTLModel<MTLJSONSerializing, JSQMessageData>

@property(copy, readonly, nonatomic) NSString * comment;
@property(copy, readonly, nonatomic) NSDate * createdAt;
@property(copy, readonly, nonatomic) NSNumber * notificationId;

@property(copy, readonly, nonatomic) NSNumber * userId;
@property(copy, readonly, nonatomic) NSNumber * itemId;

@property(copy, readonly, nonatomic) User * user;

@end
