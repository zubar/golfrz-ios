//
//  Utilities.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
+(void)dateComponentsFromNSDate:(NSDate *)mDate components:(void (^)(NSString * dayName, NSString * monthName, NSString * day, NSString * time) )dateComponents;

@end
