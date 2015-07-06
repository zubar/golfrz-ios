//
//  SubCourseServices.h
//  GolfersProject
//
//  Created by Zubair on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SubCourse;

@interface SubCourseServices : NSObject

+(void)getSubCourseDetail:(void (^)(bool status, SubCourse * subCourse))successBlock
                  failure:(void (^)(bool status, NSError * error))failureBlock;

@end
