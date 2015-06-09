//
//  Coordinates.h
//  GolfersProject
//
//  Created by Zubair on 5/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@interface Coordinate : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString * latitude;
@property (copy, nonatomic, readonly) NSString * longitude;

@end
