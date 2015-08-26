//
//  StaffCell.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/26/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "StaffCell.h"
#import "Constants.h"

@implementation StaffCell

-(void)awakeFromNib{
    
    [self addGestureAdminContact];
    [self addGestureToAdminEmail];
}


-(void) addGestureToAdminEmail{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adminEmailTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblAdminEmail setUserInteractionEnabled:YES];
    [self.lblAdminEmail addGestureRecognizer:gesture];
}


-(void) addGestureAdminContact{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adminContactTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblAdminContact setUserInteractionEnabled:YES];
    [self.lblAdminContact addGestureRecognizer:gesture];
}

-(void) adminEmailTapped{
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]) {
        
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", (NSString *)self.lblAdminEmail.text]]];
        
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:kError message:CallSupportErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil];
        [notPermitted show];
    }
    
}

-(void) adminContactTapped{
    
    NSString *contact = (NSString *)self.lblAdminContact.text;
    NSString *condensedPhoneno = [[contact componentsSeparatedByCharactersInSet:
                                   [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"]
                                    invertedSet]]
                                  componentsJoinedByString:@""];
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]) {
        if (contact.length) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", condensedPhoneno]]];
        }
        else {
            UIAlertView *notAvaliable=[[UIAlertView alloc] initWithTitle:kError message:NumberNotAvaliableErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil];
            [notAvaliable show];
        }
        
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:kError message:CallSupportErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil];
        [notPermitted show];
    }

    
}

@end
