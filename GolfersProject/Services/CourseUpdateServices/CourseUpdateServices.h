//
//  CourseUpdateServices.h
//  GolfersProject
//
//  Created by Zubair on 8/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "GolfrzError.h"
@class CourseUpdate;
@class Post;

@interface CourseUpdateServices : NSObject

+(void)getCourseUpdates:(void(^)(bool status, CourseUpdate * update))successBlock
                failure:(void(^)(bool status, GolfrzError * error))failureBlock;


+(void)getCommentsOnPostId:(NSNumber *)postId
                   success:(void(^)(bool status, Post * mPost))successBlock
                   failure:(void(^)(bool status, GolfrzError * error))failureBlock;
@end
