//
//  OrderList.h
//  GolfersProject
//
//  Created by Zubair on 6/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"


#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface Cart : MTLModel<MTLJSONSerializing>
@property(copy, nonatomic, readonly) NSArray * orders;
@end
