//
//  SideItem.h
//  GolfersProject
//
//  Created by Zubair on 6/9/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface SideItem : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber * itemId;
@property (copy, nonatomic, readonly) NSString * name;
@property (copy, nonatomic, readonly) NSNumber * price;
@property (copy, nonatomic, readonly) NSString * details;

@end
