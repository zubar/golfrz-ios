//
//  Teetime.h
//  GolfersProject
//
//  Created by Zubair on 7/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "MTLModel.h"

@interface Teetime : MTLModel<MTLJSONSerializing>

@property(nonatomic, copy, readonly) NSNumber * itemId;
@property(nonatomic, copy, readonly) NSNumber * count;
@property(nonatomic, copy, readonly) NSDate * bookedTime;
@property(nonatomic, copy, readonly) NSNumber * subCourseId;
@property(nonatomic, copy, readonly) NSDate * updatedTime;

@end
