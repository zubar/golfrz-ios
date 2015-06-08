//
//  Departments.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface Department :  MTLModel<MTLJSONSerializing>


@property (copy, nonatomic, readonly) NSNumber * departmentId;
@property (copy, nonatomic, readonly) NSString * name;
@property (copy, nonatomic, readonly) NSString * phone;
@property (copy, nonatomic, readonly) NSDate * startTime;
@property (copy, nonatomic, readonly) NSDate * endTime;


@end
