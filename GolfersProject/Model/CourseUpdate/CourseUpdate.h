//
//  CourseUpdate.h
//  GolfersProject
//
//  Created by Zubair on 8/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "MTLModel.h"

@interface CourseUpdate : MTLModel<MTLJSONSerializing>
@property(copy, readonly, nonatomic) NSArray * activities;
@end
