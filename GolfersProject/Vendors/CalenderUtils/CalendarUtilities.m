//
//  CalendarUtilities.m
//  FSTest
//
//  Created by AstroDev on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CalendarUtilities.h"
#import "NSDate+Helper.h"

@implementation CalendarUtilities

+ (NSString*)nameOfSignAtIndex:(NSInteger)aIdx {
	NSString *theResult = nil;
	
	switch ( aIdx ) {
		case  0: theResult = @"Aries"; break;
		case  1: theResult = @"Taurus"; break;
		case  2: theResult = @"Gemini"; break;
		case  3: theResult = @"Cancer"; break;
		case  4: theResult = @"Leo"; break;
		case  5: theResult = @"Virgo"; break;
		case  6: theResult = @"Libra"; break;
		case  7: theResult = @"Scorpio"; break;
		case  8: theResult = @"Sagittarius"; break;
		case  9: theResult = @"Capricorn"; break;
		case 10: theResult = @"Aquarius"; break;
		case 11: theResult = @"Pisces"; break;
	}
	
	if ( !theResult )
		theResult = @"";
	
	return theResult;
}

+ (NSInteger)signIndexFromMMDD:(NSInteger)aMMDD {
	NSInteger theResult = -1;
	
	if (( aMMDD >= 1222 ) || ( aMMDD <=  119 ))
		theResult = 9;
	else if ( aMMDD <=  218 )
		theResult = 10;
	else if ( aMMDD <=  320 )
		theResult = 11;
	else if ( aMMDD <=  419 )
		theResult =  0;
	else if ( aMMDD <=  520 )
		theResult =  1;
	else if ( aMMDD <=  621 )
		theResult =  2;
	else if ( aMMDD <=  722 )
		theResult =  3;
	else if ( aMMDD <=  822 )
		theResult =  4;
	else if ( aMMDD <=  922 )
		theResult =  5;
	else if ( aMMDD <= 1022 )
		theResult =  6;
	else if ( aMMDD <= 1121 )
		theResult =  7;
	else if ( aMMDD <= 1221 )
		theResult =  8;
	
	return theResult;
}
+ (NSInteger)signIndexFrom366Day:(NSInteger)aDD {
	return [self signIndexFromMMDD:[self MMDDFrom366Day:aDD]];
}
+ (NSInteger)MMDDFrom366Day:(NSInteger)aDay {
	aDay = ( 3660 + aDay ) % 366;
	
	if ( aDay < 31 )
		return  100+aDay+1;
	
	else if ( aDay < 31+29 )
		return  200+(aDay-31)+1;
	
	else if ( aDay < 31+29+31 )
		return  300+(aDay-31-29)+1;
	
	else if ( aDay < 31+29+31+30 )
		return  400+(aDay-31-29-31)+1;
	
	else if ( aDay < 31+29+31+30+31 )
		return  500+(aDay-31-29-31-30)+1;
	
	else if ( aDay < 31+29+31+30+31+30 )
		return  600+(aDay-31-29-31-30-31)+1;
	
	else if ( aDay < 31+29+31+30+31+30+31 )
		return  700+(aDay-31-29-31-30-31-30)+1;
	
	else if ( aDay < 31+29+31+30+31+30+31+31 )
		return  800+(aDay-31-29-31-30-31-30-31)+1;
	
	else if ( aDay < 31+29+31+30+31+30+31+31+30 )
		return  900+(aDay-31-29-31-30-31-30-31-31)+1;
	
	else if ( aDay < 31+29+31+30+31+30+31+31+30+31 )
		return 1000+(aDay-31-29-31-30-31-30-31-31-30)+1;
	
	else if ( aDay < 31+29+31+30+31+30+31+31+30+31+30 )
		return 1100+(aDay-31-29-31-30-31-30-31-31-30-31)+1;
	
	else if ( aDay < 31+29+31+30+31+30+31+31+30+31+30+31 )
		return 1200+(aDay-31-29-31-30-31-30-31-31-30-31-30)+1;
	
	else
		return 1300;
}
+ (NSInteger)MMDDFromDate:(NSDate*)aDate {
	return [[NSDate stringFromDate:aDate withFormat:@"MMdd"] intValue];
}

+ (NSInteger)dayFromMMDD:(NSInteger)aMMDD {
	NSInteger theResult = ( aMMDD % 100 ) - 1;
	switch ( aMMDD / 100 ) {
		case  1: theResult += 0; break;
		case  2: theResult += ( 31 ); break;
		case  3: theResult += ( 31+29 ); break;
		case  4: theResult += ( 31+29+31 ); break;
		case  5: theResult += ( 31+29+31+30 ); break;
		case  6: theResult += ( 31+29+31+30+31 ); break;
		case  7: theResult += ( 31+29+31+30+31+30 ); break;
		case  8: theResult += ( 31+29+31+30+31+30+31); break;
		case  9: theResult += ( 31+29+31+30+31+30+31+31 ); break;
		case 10: theResult += ( 31+29+31+30+31+30+31+31+30 ); break;
		case 11: theResult += ( 31+29+31+30+31+30+31+31+30+31 ); break;
		case 12: theResult += ( 31+29+31+30+31+30+31+31+30+31+30 ); break;
	}
	
	return theResult;
}
+ (NSInteger)dayFromDate:(NSDate*)aDate {
	return [CalendarUtilities dayFromMMDD:[CalendarUtilities MMDDFromDate:aDate]];
}

+ (NSString*)dateStringFromMMDD:(NSInteger)aMMDD {
	NSInteger aMM = aMMDD / 100;
	NSInteger aDD = aMMDD % 100;
	
//	NSMutableString *theResult = [NSMutableString stringWithFormat:@"%02d", aDD];
	NSMutableString *theResult = [NSMutableString stringWithFormat:@"%d", aDD];
	switch ( aMM ) {
		case  1: [theResult insertString:@"JAN " atIndex:0]; break;
		case  2: [theResult insertString:@"FEB " atIndex:0]; break;
		case  3: [theResult insertString:@"MAR " atIndex:0]; break;
		case  4: [theResult insertString:@"APR " atIndex:0]; break;
		case  5: [theResult insertString:@"MAY " atIndex:0]; break;
		case  6: [theResult insertString:@"JUN " atIndex:0]; break;
		case  7: [theResult insertString:@"JUL " atIndex:0]; break;
		case  8: [theResult insertString:@"AUG " atIndex:0]; break;
		case  9: [theResult insertString:@"SEP " atIndex:0]; break;
		case 10: [theResult insertString:@"OCT " atIndex:0]; break;
		case 11: [theResult insertString:@"NOV " atIndex:0]; break;
		case 12: [theResult insertString:@"DEC " atIndex:0]; break;
	}
	return theResult;
}

+(NSInteger )mmddFromStringMMDD:(NSString *)dateMMDD{
  
    if ([dateMMDD isEqual:[NSNull null]]) {
        return 0;
    }
    
    NSArray * dateFragements = [dateMMDD componentsSeparatedByString:@"/"];
    
    NSString * mmdd = [NSString stringWithFormat:@"%@%@",dateFragements[0], dateFragements[1]];
    //NSLog(@"%u", [mmdd integerValue]);
    
    return [mmdd integerValue];
}
+(NSString *)dateMMDDFromMMDD:(NSString * )dateMMDD{

    if ([dateMMDD isEqual:[NSNull null]]) {
        return @"";
    }
    
    NSArray * dateFragements = [dateMMDD componentsSeparatedByString:@"/"];
    
    
    NSString* dateString = dateFragements[1];
    
    if([dateString integerValue] < 10)
    {

        int finalDate = [dateString integerValue];
        
        finalDate = finalDate % 10;
        
        
        
        
        dateString = [NSString stringWithFormat:@"%d",finalDate];
    }
    else
    {
        dateString = dateFragements[1];
    }
    
    
    
    NSString * mmdd = [NSString stringWithFormat:@"%@. %@",[[CalendarUtilities monthNameFromNum:[dateFragements[0] integerValue]] stringByReplacingOccurrencesOfString:@" " withString:@""], dateString];
    
    return mmdd;
}

+(NSString *)monthNameFromNum:(NSInteger )month{
    
    NSString * theResult  = nil;
    switch ( month ) {
		case  1: theResult = @"JAN "; break;
		case  2: theResult = @"FEB "; break;
		case  3: theResult = @"MAR "; break;
		case  4: theResult = @"APR "; break;
		case  5: theResult = @"MAY "; break;
		case  6: theResult = @"JUN "; break;
		case  7: theResult = @"JUL "; break;
		case  8: theResult = @"AUG "; break;
		case  9: theResult = @"SEP "; break;
		case 10: theResult = @"OCT "; break;
		case 11: theResult = @"NOV "; break;
		case 12: theResult = @"DEC "; break;
	}
    return theResult;
}


+ (NSString*)dateStringFrom366Day:(NSInteger)aDay {
	return [CalendarUtilities dateStringFromMMDD:[CalendarUtilities MMDDFrom366Day:aDay]];
}
+ (NSString*)dateStringFromDate:(NSDate*)aDate {
	return [CalendarUtilities dateStringFromMMDD:[CalendarUtilities MMDDFromDate:aDate]];
}

+ (int)degreesFrom366Day:(NSInteger)aDD {
//	CGFloat theResult = (31+29+31+15-aDD)*360.0/366.0;
	int theResult = (31+29+31-aDD)*360.0/366.0;
	return theResult;
}

+ (NSInteger) daysBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
	//dates needed to be reset to represent only yyyy-mm-dd to get correct number of days between two days.
	NSDateFormatter *temp = [[NSDateFormatter alloc] init];
	[temp setDateFormat:@"yyyy-MM-dd"];
	NSDate *stDt = [temp dateFromString:[temp stringFromDate:startDate]];
	NSDate *endDt = [temp dateFromString:[temp stringFromDate:endDate]];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSCalendar *gregorian = [[NSCalendar alloc]
										initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:stDt toDate:endDt options:0];
	NSInteger days = [comps day];

	
	if (days < 0)
		days *= -1;
	
	return days;
}

+ (NSString *) getCompleteDateStringForCurrentDate
{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
	[dateFormat setDateStyle:NSDateFormatterLongStyle];
	[dateFormat setDateFormat:@"EEEE, MMMM d"];
	NSString *dateString= [dateFormat stringFromDate:[NSDate date]];
	
	
	[dateFormat setDateFormat:@"d"];
	int date = [[dateFormat stringFromDate:[NSDate date]] intValue];
	
	if (date == 1 || date == 21 || date == 31)
	{
		dateString = [dateString stringByAppendingString:@"st"];
	}
	else if (date == 2 || date == 22)
	{
		dateString = [dateString stringByAppendingString:@"nd"];
	}
	else if (date == 3 || date == 23)
	{
		dateString = [dateString stringByAppendingString:@"rd"];
	}
	else
	{
		dateString = [dateString stringByAppendingString:@"th"];
	}
    return dateString;
}

+ (NSString *) getWeekStringForCurrentDate
{
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
	
	NSDateComponents *startDateComponents = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
	[startDateComponents setDay:([startDateComponents day]-([startDateComponents weekday]-2))];
	NSDate *beginningOfWeek = [gregorian dateFromComponents:startDateComponents];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"d MMMM"];
	NSString *startDateOfWeek = [dateFormat stringFromDate:beginningOfWeek];
		
	NSDateComponents *endDateComponents = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
	[endDateComponents setDay:([endDateComponents day]-([endDateComponents weekday]-1)+7)];
	NSDate *endingOfWeek = [gregorian dateFromComponents:endDateComponents];
	NSString *endDateOfWeek = [dateFormat stringFromDate:endingOfWeek];
	
	
	return [NSString stringWithFormat:@"%@ - %@", startDateOfWeek, endDateOfWeek];
}

+ (NSString *) getMonthStringForCurrentDate
{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
	[dateFormat setDateStyle:NSDateFormatterLongStyle];
	[dateFormat setDateFormat:@"MMMM"];
	NSString *dateString= [dateFormat stringFromDate:[NSDate date]];
	
	return dateString;
}

+ (NSString *) getYearStringForCurrentDate
{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
	[dateFormat setDateStyle:NSDateFormatterLongStyle];
	[dateFormat setDateFormat:@"YYYY"];
	NSString *dateString= [dateFormat stringFromDate:[NSDate date]];
	
	return dateString;
}


@end
