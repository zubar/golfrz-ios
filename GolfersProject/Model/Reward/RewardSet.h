//
//  RewardSet.h
//  GolfersProject
//
//  Created by Zubair on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface RewardSet : MTLModel<MTLJSONSerializing>
@property (copy, nonatomic, readonly) NSArray * rewards;
@end
