//
//  PastScore.h
//  GolfersProject
//
//  Created by Zubair on 8/11/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface PastScore : MTLModel<MTLJSONSerializing>

@property(copy, nonatomic, readonly) NSNumber * itemId;
@property(copy, nonatomic, readonly) NSNumber * roundId;

@property(copy, nonatomic, readonly) NSDate * createdAt;
@property(copy, nonatomic, readonly) NSDate * updatedAt;

@property(copy, nonatomic, readonly) NSNumber * grossScore;
@property(copy, nonatomic, readonly) NSNumber * netScore;
@property(copy, nonatomic, readonly) NSNumber * skinCount;

@property(copy, nonatomic, readonly) NSNumber * subCourseId;
@property(copy, nonatomic, readonly) NSString * gameType;

@property(copy, nonatomic, readonly) NSString * subCourseName;

@end
