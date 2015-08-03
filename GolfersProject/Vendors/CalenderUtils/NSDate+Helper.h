//
//  NSDate+Helper.h
//  Codebook
//
//  Created by Billy Gray on 2/26/09.
//  Copyright 2009 Zetetic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THCalendarInfo.h"

@interface NSDate (Helper)

- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;

+ (NSString *)dbFormatString;
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

+ (NSInteger)yyyymmddFromDate:(NSDate*)aDate;
+ (NSDate*)dateFromYYYYMMDD:(NSInteger)aYYYYMMDD;

+ (NSString*)monthNameFromIndex:(NSInteger)aIdx;
+ (NSString*)abbreviatedMonthNameFromIndex:(NSInteger)aIdx;

+ (NSDate *)NSDateForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString;

-(NSDate *)toLocalTime;
-(NSDate *)toGlobalTime;
-(NSString *)serverFormatDate;
-(NSDate *)dateWithTimeComponentsZeroSet;

@end