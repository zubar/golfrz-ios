//
//  User.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/18/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>



@interface User : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString * authToken;
@property (copy, nonatomic, readonly) NSString * email;
@property (assign, nonatomic, readonly) NSNumber * success;

@end

