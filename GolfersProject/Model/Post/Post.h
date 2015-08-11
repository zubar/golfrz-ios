//
//  Post.h
//  GolfersProject
//
//  Created by Zubair on 8/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "MTLModel.h"


@interface Post : MTLModel<MTLJSONSerializing>
@property(copy, nonatomic, readonly) NSArray * comments;
@end
