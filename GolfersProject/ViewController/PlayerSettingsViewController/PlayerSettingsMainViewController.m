//
//  PlayerSettingsMainViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/28/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PlayerSettingsMainViewController.h"

@interface PlayerSettingsMainViewController ()

@end

@implementation PlayerSettingsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGestureToEditProfile];
    [self addGestureToLogout];
    [self addGestureToResetPassword];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) addGestureToEditProfile{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editProfileTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblEditProfile setUserInteractionEnabled:YES];
    [self.lblEditProfile addGestureRecognizer:gesture];
}


-(void) addGestureToResetPassword{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetPasswordTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblResetPassword setUserInteractionEnabled:YES];
    [self.lblResetPassword addGestureRecognizer:gesture];
}


-(void) addGestureToLogout{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblLogout setUserInteractionEnabled:YES];
    [self.lblLogout addGestureRecognizer:gesture];
}


- (void) editProfileTapped{
    
}

- (void) resetPasswordTapped{
    
}

- (void) logoutTapped {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma TextFieldMethods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


@end
