//
//  Round.h
//  GolfersProject
//
//  Created by Zubair on 7/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface RoundData : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray * subCourses;
@property (nonatomic, copy, readonly) NSArray * scoreTypes;
@property (nonatomic, copy, readonly) NSArray * gameTypes;

@end
