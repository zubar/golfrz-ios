//
//  Shot.h
//  GolfersProject
//
//  Created by Zubair on 8/16/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface Shot : MTLModel<MTLJSONSerializing>

@property(copy, nonatomic, readonly) NSNumber * itemId;
@property(copy, nonatomic, readonly) NSNumber * holeId;
@property(copy, nonatomic, readonly) NSNumber * userId;
@property(copy, nonatomic, readonly) NSNumber * roundId;
@property(copy, nonatomic, readonly) NSString * shotType;

@end

