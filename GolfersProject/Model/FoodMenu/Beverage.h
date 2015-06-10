//
//  Beverage.h
//  GolfersProject
//
//  Created by Zubair on 6/9/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface Beverage : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber * foodId;
@property (copy, nonatomic, readonly) NSString * name;
@property (copy, nonatomic, readonly) NSNumber * price;
@property (copy, nonatomic, readonly) NSString * imageUrl;
@property (copy, nonatomic, readonly) NSString * details;

@end
