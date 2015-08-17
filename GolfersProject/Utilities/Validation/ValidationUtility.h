//
//  ValidationUtility.h
//  GolfersProject
//
//  Created by Ali Ehsan on 8/17/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidationUtility : NSObject

+ (BOOL)isBlankLine:(NSString *)string;

+ (BOOL)isEmail:(NSString *)string;

+ (BOOL)isOnlyNumbers:(NSString *)string;

@end
