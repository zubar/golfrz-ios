//
//  Round.h
//  GolfersProject
//
//  Created by Zubair on 7/23/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>
#import "RoundMetaData.h"

@interface Round : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) RoundMetaData * roundData;

@end
