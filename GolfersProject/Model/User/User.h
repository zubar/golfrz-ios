//
//  User.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/29/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@interface User :  MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber * memberId;
@property (copy, nonatomic, readonly) NSNumber * userId;
@property (copy, nonatomic, readonly) NSString * email;
@property (copy, nonatomic, readonly) NSString * firstName;
@property (copy, nonatomic, readonly) NSString * lastName;
@property (copy, nonatomic, readonly) NSNumber * handicap;

@property (copy, nonatomic, readonly) NSString * imgPath;

@end