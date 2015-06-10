//
//  FoodMenu.h
//  GolfersProject
//
//  Created by Zubair on 6/9/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//


#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface Menu : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSArray * foodItems;
@property (copy, nonatomic, readonly) NSArray * beverageItems;

@end
