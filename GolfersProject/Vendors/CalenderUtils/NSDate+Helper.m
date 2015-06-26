//
//  NSDate+Helper.m
//  Codebook
//
//  Created by Billy Gray on 2/26/09.
//  Copyright 2009 Zetetic LLC. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
- (NSUInteger)daysAgo {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit) 
											   fromDate:self
												 toDate:[NSDate date]
												options:0];
	return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
	// get a midnight version of ourself:
	NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
	
	return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
	return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
	NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
	NSString *text = nil;
	switch (daysAgo) {
		case 0:
			text = @"Today";
			break;
		case 1:
			text = @"Yesterday";
			break;
		default:
			text = [NSString stringWithFormat:@"%lu days ago", (unsigned long)daysAgo];
	}
	return text;
}

+ (NSString *)dbFormatString {
	return @"yyyy-MM-dd HH:mm:ss";
}

+ (NSDate *)dateFromString:(NSString *)string {
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:[NSDate dbFormatString]];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
	NSDate *date = [inputFormatter dateFromString:string];
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:date];
	return timestamp_str;
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [NSDate stringFromDate:date withFormat:[NSDate dbFormatString]];
}

+ (NSDate*)dateFromYYYYMMDD:(NSInteger)aYYYYMMDD {
	NSInteger theYYYY =   aYYYYMMDD/10000;
	NSInteger theMM   = ( aYYYYMMDD - theYYYY*10000 )/100;
	NSInteger theDD   = ( aYYYYMMDD % 100 );
	
	theYYYY = [THCalendarInfo currentYear];
	return [NSDate dateFromString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld 00:00:00 +0000", (long)theYYYY, (long)theMM, (long)theDD]];
}
+ (NSInteger)yyyymmddFromDate:(NSDate*)aDate {
	NSString *theResult = [NSDate stringFromDate:aDate withFormat:@"yyyyMMdd"];	
	
	return [theResult intValue];
}

+ (NSString*)birthDateStringFromYYYYMMDD:(NSInteger)aYYYYMMDD abbreviated:(BOOL)aAbbr {
	NSInteger theYYYY =   aYYYYMMDD / 10000;
	NSInteger theMM   = ( aYYYYMMDD - theYYYY*10000 )/100;
	NSInteger theDD   = ( aYYYYMMDD % 100 );
	
	if ( aAbbr )
		return [NSString stringWithFormat:@"%@ %ld", 
				[[NSDate abbreviatedMonthNameFromIndex:theMM] uppercaseString],
				(long)theDD];
	else
		return [NSString stringWithFormat:@"%@ %ld", 
				[[NSDate monthNameFromIndex:theMM] uppercaseString],
				(long)theDD];
}

+ (NSString*)abbreviatedMonthNameFromIndex:(NSInteger)aIdx {
	NSString *theResult = nil;
	switch ( aIdx ) {
		case  1: theResult = @"Jan."; break;
		case  2: theResult = @"Feb."; break;
		case  3: theResult = @"Mar."; break;
		case  4: theResult = @"Apr."; break;
		case  5: theResult = @"May "; break;
		case  6: theResult = @"Jun."; break;
		case  7: theResult = @"Jul."; break;
		case  8: theResult = @"Aug."; break;
		case  9: theResult = @"Sep."; break;
		case 10: theResult = @"Oct."; break;
		case 11: theResult = @"Nov."; break;
		case 12: theResult = @"Dec."; break;
		default: theResult = @""; break;
	}
	
	return theResult;
}
+ (NSString*)monthNameFromIndex:(NSInteger)aIdx {
	NSString *theResult = nil;
	switch ( aIdx ) {
		case  1: theResult = @"January"; break;
		case  2: theResult = @"February"; break;
		case  3: theResult = @"March"; break;
		case  4: theResult = @"April"; break;
		case  5: theResult = @"May"; break;
		case  6: theResult = @"June"; break;
		case  7: theResult = @"July"; break;
		case  8: theResult = @"August"; break;
		case  9: theResult = @"September"; break;
		case 10: theResult = @"October"; break;
		case 11: theResult = @"November"; break;
		case 12: theResult = @"December"; break;
		default: theResult = @""; break;
	}
	
	return theResult;
}



+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
	/* 
	 * if the date is in today, display 12-hour time with meridian,
	 * if it is within the last 7 days, display weekday name (Friday)
	 * if within the calendar year, display as Jan 23
	 * else display as Nov 11, 2008
	 */
	
	NSDate *today = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
													 fromDate:today];
	
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
	
	NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
	NSString *displayString = nil;
	
	// comparing against midnight
	if ([date compare:midnight] == NSOrderedDescending) {
		if (prefixed) {
			[displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
		} else {
			[displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
		}
	} else {
		// check if date is within last 7 days
		NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
		[componentsToSubtract setDay:-7];
		NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
		if ([date compare:lastweek] == NSOrderedDescending) {
			[displayFormatter setDateFormat:@"EEEE"]; // Tuesday
		} else {
			// check if same calendar year
			NSInteger thisYear = [offsetComponents year];
			
			NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
														   fromDate:date];
			NSInteger thatYear = [dateComponents year];      
			if (thatYear >= thisYear) {
				[displayFormatter setDateFormat:@"MMM d"];
			} else {
				[displayFormatter setDateFormat:@"MMM d, YYYY"];
			}
		}
		if (prefixed) {
			NSString *dateFormat = [displayFormatter dateFormat];
			NSString *prefix = @"'on' ";
			[displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
		}
	}
	
	// use display formatter to return formatted date string
	displayString = [displayFormatter stringFromDate:date];
	return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
	return [self stringForDisplayFromDate:date prefixed:NO];
}


static NSDateFormatter *sUserVisibleDateFormatter = nil;

+ (NSDate *)NSDateForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString {
    /*
     Returns a user-visible date time string that corresponds to the specified
     RFC 3339 date time string. Note that this does not handle all possible
     RFC 3339 date time strings, just one of the most common styles.
     */
    
    // If the date formatters aren't already set up, create them and cache them for reuse.
    static NSDateFormatter *sRFC3339DateFormatter = nil;
    if (sRFC3339DateFormatter == nil) {
        sRFC3339DateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
        [sRFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [sRFC3339DateFormatter dateFromString:rfc3339DateTimeString];
    
    
//    NSString *userVisibleDateTimeString;
//    if (date != nil) {
//        if (sUserVisibleDateFormatter == nil) {
//            sUserVisibleDateFormatter = [[NSDateFormatter alloc] init];
//            [sUserVisibleDateFormatter setDateStyle:NSDateFormatterShortStyle];
//            [sUserVisibleDateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        }
//        // Convert the date object to a user-visible date string.
//        userVisibleDateTimeString = [sUserVisibleDateFormatter stringFromDate:date];
//    }
    return date;
}
@end