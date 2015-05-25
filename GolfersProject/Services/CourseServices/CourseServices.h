//
//  CourseServices.h
//  GolfersProject
//
//  Created by Zubair on 5/20/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Course;

@interface CourseServices : NSObject

+(void)courseInfo:(void (^)(bool status, Course * currentCourse))successBlock failure:(void (^)(bool status, NSError * error))failureBlock;


+(void)setCurrentCourse:(Course *)mCourse;
+(Course *)currentCourse;

@end
