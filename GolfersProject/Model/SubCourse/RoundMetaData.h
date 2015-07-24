//
//  Round.h
//  GolfersProject
//
//  Created by Zubair on 7/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>
@class SubCourse;
@class ScoreType;
@class GameType;

@interface RoundMetaData : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray * subCourses;
@property (nonatomic, copy, readonly) NSArray * scoreTypes;
@property (nonatomic, copy, readonly) NSArray * gameTypes;


@property (nonatomic, copy, readonly) SubCourse * activeCourse;
@property (nonatomic, copy, readonly) ScoreType * activeScoreType;
@property (nonatomic, copy, readonly) GameType * activeGameType;

@property (nonatomic, copy, readonly) NSNumber * roundId;
@property (nonatomic, copy, readonly) NSString * name;
@property (nonatomic, copy, readonly) NSString * status;

@end
