//
//  Utility.h
//  School Diary
//
//  Created by Asad Tkxel on 03/10/2014.
//  Copyright (c) 2014 Tkxel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

+(void) showAlertViewWithTitle:(NSString *)title AndMessage:(NSString *)message;
+(NSString *) convertDate:(NSString *)dateInString InFormat:(NSString *)format;
+(NSString *)convertDate:(NSString *)dateInString fromFormat:(NSString *)fromFormat InFormat:(NSString *)inFormat;
+(NSString *)convertDateObject:(NSDate *)dateInDate InFormat:(NSString *)format;
+(NSDate *)convertDateString:(NSString *)dateString InDateObjectFormat:(NSString *)format;
+(NSString *) getCurrentDateAndTime;
+(NSString *) getCurrentTimeInMiliSeconds;
+ (NSString *) getCurrentTimeIn12HourFormat;
+(NSArray *) sortArrayUsingDate:(NSArray *)unsortedArray InAscendingOrder:(BOOL)isAscending;
+(NSDictionary *) getFormattedData:(NSArray *)array;
+(NSString *) getCurrentDateWithFormat:(NSString*)format;
+(NSArray *) sortDateArray:(NSArray *)unsortedArrayOfStrings;
+(NSArray *) sortDateArrayWithDecendingOrder:(NSArray *)unsortedArrayOfStrings;

+(void) shareOnSocialMedia;
+(void) showImageInFull:(UIImage*)image;

+(int)heightRequiredToShowText:(NSString *)text forFont:(UIFont *)font inWidth:(int)width;

+(CGSize)getSizeForWidth:(CGFloat)width height:(CGFloat)height;

+ (UIViewController*)topViewController;

+(void) setUpToolbarForField:(id)textField withTwoButtons:(BOOL)isTwoButton andDelegate:(id)delegate;

@end
