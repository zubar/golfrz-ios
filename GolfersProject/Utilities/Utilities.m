//
//  Utilities.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Utilities.h"
#import <UIKit/UIKit.h>

@implementation Utilities


+(void)dateComponentsFromNSDate:(NSDate *)mDate components:(void (^)(NSString * dayName, NSString * monthName, NSString * day, NSString * time, NSString * minutes, NSString * timeAndMinute) )dateComponents{

    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [cal setLocale:[NSLocale currentLocale]];

    NSDateComponents *timeStamp = [[NSCalendar currentCalendar] components: NSCalendarUnitWeekday | NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:mDate];

    dateComponents([Utilities dayName:timeStamp.weekday],
                   [Utilities monthName:timeStamp.month],
                   [NSString stringWithFormat:@"%ld", (long)timeStamp.day],
                   [Utilities timeInAMPMfrom24hour:(int)timeStamp.hour],
                   [NSString stringWithFormat:@"%.2ld",(long)[timeStamp minute]],
                   [NSString stringWithFormat:@"%@",[Utilities timeInAMPMfrom24hour:(int)timeStamp.hour minute:(int)timeStamp.minute]]
                   );

}


+(NSString *)dayName:(NSInteger)num{
    
    switch (num) {
        case 1:
            return @"Sunday";
        case 2:
            return @"Monday";
        case 3:
            return @"Tuesday";
        case 4:
            return @"Wednesday";
        case 5:
            return @"Thursday";
        case 6:
            return @"Friday";
            break;
        case 7:
            return @"Saturday";
        default:
            break;
    }
    return @"Unknown";
}


+(NSString *)monthName:(NSInteger)num{
    
    switch (num) {
        case 1:
            return @"January";
        case 2:
            return @"February";
        case 3:
            return @"March";
        case 4:
            return @"April";
        case 5:
            return @"May";
        case 6:
            return @"June";
        case 7:
            return @"July";
        case 8:
            return @"August";
        case 9:
            return @"September";
        case 10:
            return @"October";
        case 11:
            return @"November";
        case 12:
            return @"December";
        default:
            break;
    }
    return @"Unknown";
}


+(NSString *)timeInAMPMfrom24hour:(int)hour{
    (hour > 11 && hour <= 23 ? --hour : ++hour);
    if (hour > 11 && hour <= 23 ) {
        return [NSString stringWithFormat:@"%d PM", hour-11];
    }else{
        return [NSString stringWithFormat:@"%d AM", hour];
    }
}

+(NSString *)timeInAMPMfrom24hour:(int)hour minute:(long)min{
    (hour > 11 && hour <= 23 ? --hour : ++hour);
    if (hour > 11 && hour <= 23 ) {
        return [NSString stringWithFormat:@"%d:%.2ld PM", hour-11, min];
    }else{
        return [NSString stringWithFormat:@"%d:%.2ld AM", hour, min];
    }
}

+(void)displayErrorAlertWithMessage:(NSString *)errmsg
{
    [[[UIAlertView alloc] initWithTitle:@"Try Again" message:errmsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

+(void)displayErrorAlertWithTitle:(NSString *)title Message:(NSString *)errmsg
{
   [[[UIAlertView alloc] initWithTitle:title message:errmsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}


@end
