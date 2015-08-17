//
//  ValidationUtility.m
//  GolfersProject
//
//  Created by Ali Ehsan on 8/17/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ValidationUtility.h"

@implementation ValidationUtility

+ (BOOL)isBlankLine:(NSString *)string {
    return ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0);
}

+ (BOOL)isEmail:(NSString *)string {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

+ (BOOL)isOnlyNumbers:(NSString *)string {
    NSString *numberRegex = @"[0-9]+";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:string];
}

@end
