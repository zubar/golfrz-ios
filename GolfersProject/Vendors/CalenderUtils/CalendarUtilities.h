//
//  CalendarUtilities.h
//  FSTest
//
//  Created by AstroDev on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalendarUtilities : NSObject {

}

+ (NSInteger)MMDDFrom366Day:(NSInteger)aDay;
+ (NSInteger)MMDDFromDate:(NSDate*)aDate;

+ (NSInteger)dayFromMMDD:(NSInteger)aMMDD;
+ (NSInteger)dayFromDate:(NSDate*)aDate;

+ (NSString*)dateStringFromMMDD:(NSInteger)aMMDD;
+ (NSString*)dateStringFrom366Day:(NSInteger)aDay;
+ (NSString*)dateStringFromDate:(NSDate*)aDate;

+ (int)degreesFrom366Day:(NSInteger)aDD;
+ (NSInteger) daysBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

+ (NSString *) getCompleteDateStringForCurrentDate;
+ (NSString *) getWeekStringForCurrentDate;
+ (NSString *) getMonthStringForCurrentDate;
+ (NSString *) getYearStringForCurrentDate;

+(NSString *)dateMMDDFromMMDD:(NSString * )dateMMDD;
+(NSInteger )mmddFromStringMMDD:(NSString *)dateMMDD;

+(NSString *)monthNameFromNum:(NSInteger )month;


@end
