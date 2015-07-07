//
//  GameType.h
//  GolfersProject
//
//  Created by Zubair on 7/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface GameType : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber * gameTypeId;
@property (nonatomic, copy, readonly) NSString * name;

@end

