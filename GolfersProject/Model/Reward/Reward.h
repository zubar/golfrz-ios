//
//  Reward.h
//  GolfersProject
//
//  Created by Zubair on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface Reward : MTLModel<MTLJSONSerializing>

@property(copy, nonatomic, readonly) NSNumber * itemId;
@property(copy, nonatomic, readonly) NSString * name;
@property(copy, nonatomic, readonly) NSString * rewardDetail;
@property(copy, nonatomic, readonly) NSNumber * pointsRequired;
@property(copy, nonatomic, readonly) NSString * rewardBreif;
@property(copy, nonatomic, readonly) NSString * imagePath;

@end
