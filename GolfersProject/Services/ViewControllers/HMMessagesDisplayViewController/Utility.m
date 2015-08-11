//
//  Utility.m
//  School Diary
//
//  Created by Asad Tkxel on 03/10/2014.
//  Copyright (c) 2014 Tkxel. All rights reserved.
//

#import "Utility.h"
#import "UIImage+Resize.h"
#import "Constants.h"

#define kMaxHeightToResize 2000
#define kMaxWidth 270
#define kMaxHeight 400

@implementation Utility

#pragma mark - AlertView

+(void) showAlertViewWithTitle:(NSString *)title AndMessage:(NSString *)message
{
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}


#pragma mark - Date Conversion

+(NSString *)convertDate:(NSString *)dateInString InFormat:(NSString *)format
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
    
	NSDate * date = [dateFormatter dateFromString:dateInString];
    [dateFormatter setDateFormat:format];
    NSString * dateString = [dateFormatter stringFromDate:date];
    
    
    return dateString;
}

+(NSString *)convertDate:(NSString *)dateInString fromFormat:(NSString *)fromFormat InFormat:(NSString *)inFormat
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:fromFormat];
    
    NSDate * date = [dateFormatter dateFromString:dateInString];
    [dateFormatter setDateFormat:inFormat];
    NSString * dateString = [dateFormatter stringFromDate:date];
    
    
    return dateString;
}

+(NSString *)convertDateObject:(NSDate *)dateInDate InFormat:(NSString *)format
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    
    [dateFormatter setDateFormat:format];
    NSString * dateString = [dateFormatter stringFromDate:dateInDate];
    
    return dateString;
}

+(NSDate *)convertDateString:(NSString *)dateString InDateObjectFormat:(NSString *)format
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    
    [dateFormatter setDateFormat:format];
    NSDate * dateInDate = [dateFormatter dateFromString:dateString];
    
    return dateInDate;
}

+(NSString *)getCurrentDateAndTime
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
    NSString * str =[dateFormatter stringFromDate:[NSDate date]];
    return str;
}

+(NSString *)getCurrentDateWithFormat:(NSString*)format
{
    NSDate * now = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString * date = [dateFormatter stringFromDate:now];
    
    return date;
}

+ (NSString *) getCurrentTimeInMiliSeconds
{
    NSDate * date = [NSDate date];
    NSString * timeInMiliSeconds = [NSString stringWithFormat:@"%lld", [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]];
    return timeInMiliSeconds;
}

+ (NSString *) getCurrentTimeIn12HourFormat
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString * currentTimeInString = [dateFormatter stringFromDate:[NSDate date]];
    return currentTimeInString;
}


#pragma mark - Sort Array using Dates

//+ (NSArray *) sortArrayUsingDate:(NSArray *)unsortedArray InAscendingOrder:(BOOL)isAscending
//{
//    for(DTOObject * dtoObject in unsortedArray)
//    {
//        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
//        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//        [dateFormatter setLocale:locale];
//        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
//        
//        dtoObject.dateAssignedInDate = [dateFormatter dateFromString:dtoObject.dateAssigned];
//    }
//    
//    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateAssignedInDate" ascending:isAscending];
//    NSArray * sortedArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
//    
//    return sortedArray;
//}

//+(NSDictionary *) getFormattedData:(NSArray *)array
//{
//    NSMutableDictionary * formattedDictionary = [[NSMutableDictionary alloc]init];
//    
//    for(DTOObject * dtoObject in array)
//    {
//        dtoObject.dateAssignedWithDayMothYear = [Utility convertDate:dtoObject.dateAssigned InFormat:@"dd/MM/yy"];
//    }
//    
//    int count = (int)[[array valueForKeyPath:@"@distinctUnionOfObjects.dateAssignedWithDayMothYear"] count];
//    int index = -1;
//    NSMutableArray * formattedArray = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < count; i++)
//    {
//        NSMutableArray * subArray = [[NSMutableArray alloc] init];
//        [formattedArray addObject:subArray];
//    }
//    
//    
//    for(DTOObject * dtoObject in array)
//    {
//
//        if([formattedDictionary objectForKey:dtoObject.dateAssignedWithDayMothYear] == nil)
//        {
//            index = index + 1;
//            [formattedArray[index] addObject:dtoObject];
//            [formattedDictionary setObject:formattedArray[index] forKey:dtoObject.dateAssignedWithDayMothYear];
//        }
//        else
//        {
//            [formattedArray[index] addObject:dtoObject];
//            [formattedDictionary setObject:formattedArray[index] forKey:dtoObject.dateAssignedWithDayMothYear];
//        }
//    }
//    
//    return formattedDictionary;
//}

+(NSArray *) sortDateArray:(NSArray *)unsortedArrayOfStrings
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy"];
    
    NSMutableArray * unsortedArrayOfDates = [[NSMutableArray alloc]init];
    NSMutableArray * sortedArrayOfStrings = [[NSMutableArray alloc]init];
    
    for(NSString * object in unsortedArrayOfStrings)
    {
        NSDate * date = [dateFormatter dateFromString:object];
        [unsortedArrayOfDates addObject:date];
    }
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    NSArray * sortedArrayOfDates = [unsortedArrayOfDates sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    for(NSDate * object in sortedArrayOfDates)
    {
        NSString * dateInString = [dateFormatter stringFromDate:object];
        [sortedArrayOfStrings addObject:dateInString];
    }
    
    return sortedArrayOfStrings;
}
+(NSArray *) sortDateArrayWithDecendingOrder:(NSArray *)unsortedArrayOfStrings
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy"];
    
    NSMutableArray * unsortedArrayOfDates = [[NSMutableArray alloc]init];
    NSMutableArray * sortedArrayOfStrings = [[NSMutableArray alloc]init];
    
    for(NSString * object in unsortedArrayOfStrings)
    {
        NSDate * date = [dateFormatter dateFromString:object];
        [unsortedArrayOfDates addObject:date];
    }
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    NSArray * sortedArrayOfDates = [unsortedArrayOfDates sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    for(NSDate * object in sortedArrayOfDates)
    {
        NSString * dateInString = [dateFormatter stringFromDate:object];
        [sortedArrayOfStrings addObject:dateInString];
    }
    
    return sortedArrayOfStrings;
}



#pragma mark - Sharing On Social Media

//+(void) shareOnSocialMedia
//{
//    CGSize size = [UIScreen mainScreen].bounds.size;
//    ShareView * shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    UIView * shareButtonContainerView = shareView.getShareButtonsContainerView;
//    
//    [shareView setAlpha:0.0f];
//    
//    HMAppDelegate * delgate = [UIApplication sharedApplication].delegate;
//    [delgate.navigationController.topViewController.view addSubview:shareView];
//    [delgate.navigationController.topViewController.view bringSubviewToFront:shareView];
//    
//    // Show transparent share view with fade in animation
//    [UIView animateWithDuration:0.5f animations:^{
//        
//        [shareView setAlpha:1.0f];
//        
//    }completion:^(BOOL finished){
//        
//        // Show share buttons container view from bottom to top
//        [UIView animateWithDuration:0.4f animations:^{
//            
//            [shareButtonContainerView setFrame:CGRectMake(0, 368, 320, 200)];
//            [shareView addSubview:shareButtonContainerView];
//            
//        }];
//    }];
//    
//}



#pragma mark - Show full image

//+(void) showImageInFull:(UIImage *)image
//{
//    CGSize size = [UIScreen mainScreen].bounds.size;
//    HMFullScreenImage * shareView = [[HMFullScreenImage alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) withImage:image];
//    HMAppDelegate * delgate = [UIApplication sharedApplication].delegate;
//    [delgate.navigationController.topViewController.view addSubview:shareView];
//    [delgate.navigationController.topViewController.view bringSubviewToFront:shareView];
//}
//
//
//
//#pragma mark - Calculate Sizes
//
+(int)heightRequiredToShowText:(NSString *)text forFont:(UIFont *)font inWidth:(int)width
{
    CGRect labelRect = [text
                        boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{
                                     NSFontAttributeName : font
                                     }
                        context:nil];
    return ceil(labelRect.size.height);
}

+(CGSize)getSizeForWidth:(CGFloat)width height:(CGFloat)height{
    
    int newHeight = (height / width) * kMaxWidth;
    if (newHeight>kMaxHeight) {
        newHeight = kMaxHeight;
    }
    return CGSizeMake(kMaxWidth, newHeight);
    
    CGSize size = [UIImage resizedImageSizeToFitInSize:CGSizeMake(kMaxWidth, kMaxHeightToResize) actualSize:CGSizeMake(width, height) scaleIfSmaller:NO];
    //size.width = 270;
    if (size.height>kMaxHeight) {
        size.height = kMaxHeight;
    }
    
    return size;
}


#pragma mark - Top controller

+ (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


#pragma mark - UIToolbar with clear/done button
//calling class should implement cancelNumberPad method for cancel button and doneNumberPad method for apply button
+(void) setUpToolbarForField:(id)textField withTwoButtons:(BOOL)isTwoButton andDelegate:(id)delegate
{
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.backgroundColor = [UIColor clearColor];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.translucent = YES;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:delegate action:@selector(doneWithNumberPad:)];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           doneButton,
                           nil];
    
    [numberToolbar sizeToFit];
    
    if ([textField isKindOfClass:[UITextField class]]) {
        UITextField *temp = (UITextField*)textField;
        temp.inputAccessoryView = numberToolbar;
    }
    else if([textField isKindOfClass:[UITextView class]]){
        UITextView *textView = (UITextView*)textField;
        textView.inputAccessoryView = numberToolbar;
    }
}
@end
