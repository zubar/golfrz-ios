//
//  Teebox.h
//  GolfersProject
//
//  Created by Zubair on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface Teebox : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber * itemId;
@property (nonatomic, copy, readonly) NSNumber * handicap;
@property (nonatomic, copy, readonly) NSString * name;
@property (nonatomic, copy, readonly) NSNumber * holeId;

@end

