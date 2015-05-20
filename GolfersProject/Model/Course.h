//
//  Course.h
//  GolfersProject
//
//  Created by Zubair on 5/20/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@interface Course :  MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString * courseName;
@property (copy, nonatomic, readonly) NSString * courseLogo;
@property (copy, nonatomic, readonly) NSString * courseBackgroundImage;
@property (copy, nonatomic, readonly) NSString * courseTheme;
@property (copy, nonatomic, readonly) NSString * courseState;
@property (copy, nonatomic, readonly) NSString * courseCity;
@property (copy, nonatomic, readonly) NSString * courseAddress;

@end

