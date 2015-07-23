//
//  RoundPlayers.h
//  GolfersProject
//
//  Created by Zubair on 7/23/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "MTLModel.h"

@interface RoundPlayers : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSArray * players;

@end
