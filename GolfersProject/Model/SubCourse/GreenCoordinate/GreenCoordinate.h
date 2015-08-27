//
//  GreenCoordinate.h
//  GolfersProject
//
//  Created by Zubair on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

#define GREEN_MIDDLE @"green_middle"
#define GREEN_FRONT  @"green_front"
#define GREEN_BACK   @"green_back"
#define GREEN_UNDEFINED @"green_key_undefined"

@interface GreenCoordinate : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString * latitude;
@property (nonatomic, copy, readonly) NSString * longitude;
@property (nonatomic, copy, readonly) NSString * type;

@end
