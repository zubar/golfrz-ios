//
//  CourseServices.h
//  GolfersProject
//
//  Created by Zubair on 5/20/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Course;
@class GolfrzError;

@interface CourseServices : NSObject

+(void)courseInfo:(void (^)(bool, id tObject))successBlock
          failure:(void (^)(bool, NSError *))failureBlock;


+(void)checkInToCurrentCourse:(void(^)(bool status, id responseObject))successBlock
                      failure:(void (^)(bool, NSError *))failureBlock;


+(void)courseDetailInfo:(void (^)(bool status, Course * currentCourse))successBlock
                failure:(void (^)(bool status, GolfrzError * error))failureBlock;

+(void)getCheckInCount:(void(^)(bool status, NSNumber * countOfCheckin))successBlock
               failure:(void(^)(bool status, GolfrzError * error))failureBlock;

+(void)getEnabledFeatures:(void(^)(bool status, NSArray * enabledFeatures))successBlock
                  failure:(void(^)(bool status, GolfrzError * error))failureBlock;

+(void)setCurrentCourse:(Course *)mCourse;
+(Course *)currentCourse;


@end
