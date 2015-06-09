//
//  EventsList.h
//  GolfersProject
//
//  Created by Zubair on 5/27/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface EventList : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSArray * items;
@end
