//
//  SubCourse.h
//  GolfersProject
//
//  Created by Zubair on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface SubCourse : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber * subCourseId;
@property (nonatomic, copy, readonly) NSString * name;
@property (nonatomic, copy, readonly) NSArray * holes;

@end
