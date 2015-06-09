//
//  StaffType.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface StaffType :  MTLModel<MTLJSONSerializing>


@property (copy, nonatomic, readonly) NSNumber * typeId;
@property (copy, nonatomic, readonly) NSString * name;


@end
