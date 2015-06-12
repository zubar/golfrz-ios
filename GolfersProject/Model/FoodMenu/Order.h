//
//  Order.h
//  GolfersProject
//
//  Created by Zubair on 6/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface Order : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber * orderId;
@property (copy, nonatomic, readonly) NSString * name;
@property (copy, nonatomic, readonly) NSNumber * price;
@property (copy, nonatomic, readonly) NSNumber * quantity;
@property (copy, nonatomic, readonly) NSString * details;
@property (copy, nonatomic, readonly) NSString * imageUrl;

@end

