//
//  Hole.h
//  GolfersProject
//
//  Created by Zubair on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface Hole : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber * itemId;
@property (nonatomic, copy, readonly) NSNumber * par;
@property (nonatomic, copy, readonly) NSNumber * holeNumber;
@property (nonatomic, copy, readonly) NSNumber * yards;

@property (nonatomic, copy, readonly) NSArray * teeboxes;
@property (nonatomic, copy, readonly) NSArray * greenCoordinates;

@end
