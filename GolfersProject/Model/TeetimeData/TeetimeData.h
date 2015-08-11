//
//  TeetimeData.h
//  GolfersProject
//
//  Created by Zubair on 7/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "MTLModel.h"

@interface TeetimeData : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy, readonly) NSArray * teetimes;
@end
