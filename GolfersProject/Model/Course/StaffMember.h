//
//  Staff.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Mantle/Mantle.h>

@class StaffType;

@interface StaffMember :  MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber * staffId;
@property (copy, nonatomic, readonly) NSNumber * courseId;
@property (copy, nonatomic, readonly) NSNumber * staffTypeId;
@property (copy, nonatomic, readonly) NSString * name;
@property (copy, nonatomic, readonly) NSString * email;
@property (copy, nonatomic, readonly) NSString * imageUrl;
@property (copy, nonatomic, readonly) NSString * phone;

@property (copy, nonatomic, readonly) StaffType * type;

@end
