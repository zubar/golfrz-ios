//
//  GreenCoordinate.h
//  GolfersProject
//
//  Created by Zubair on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface GreenCoordinate : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString * latitude;
@property (nonatomic, copy, readonly) NSString * longitude;
@property (nonatomic, copy, readonly) NSString * type;

@end
