//
//  Round.h
//  GolfersProject
//
//  Created by Zubair on 7/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface RoundMetaData : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray * subCourses;
@property (nonatomic, copy, readonly) NSArray * scoreTypes;
@property (nonatomic, copy, readonly) NSArray * gameTypes;


@property (nonatomic, copy, readonly) NSNumber * roundId;
@property (nonatomic, copy, readonly) NSString * name;
@property (nonatomic, copy, readonly) NSString * status;

@end
