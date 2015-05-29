//
//  PlayerSettingsMainViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/28/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PlayerSettingsMainViewController.h"
#import "AuthenticationService.h"
#import "InitialViewController.h"
#import "ForgotPasswordViewController.h"
#import "UserServices.h"
#import "User.h"

@interface PlayerSettingsMainViewController ()

@end

@implementation PlayerSettingsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Assuming the view will always be created in non-editing mode.
    isEditing = false;
    
    [self addGestureToEditProfile];
    [self addGestureToLogout];
    [self addGestureToResetPassword];
    
    
    
}
-(void)loadUserInfo{
    User * mUser = [UserServices currentUser];
    [self.txtFirstName setText:[mUser firstName]];
    [self.txtLastName setText:[mUser firstName]];
    [self.txtEmailAddress setText:[mUser email]];
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
    
    if (!isEditing) {
        isEditing = true;
        [self.lblEditProfile setText:@"Save Profile"];
        [self makeUserInfoFieldsEditable:isEditing];
        [self.txtFirstName becomeFirstResponder];
    }else{
        isEditing = false;
        [self.lblEditProfile setText:@"Edit Profile"];
        [self makeUserInfoFieldsEditable:isEditing];
        [self.view.subviews makeObjectsPerformSelector:@selector(resignFirstResponder)];
        [self upDateUserFirstName:[self.txtFirstName text] lastName:[self.txtLastName text] email:[self.txtEmailAddress text]];
    }
    
}

-(void)makeUserInfoFieldsEditable:(BOOL)yesNo{
    [self.txtFirstName setEnabled:yesNo];
    [self.txtLastName setEnabled:yesNo];
    [self.txtEmailAddress setEnabled:yesNo];
}

- (void)resetPasswordTapped{
   
    ForgotPasswordViewController *forgetPasswordVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
    
}

- (void)logoutTapped {
    [AuthenticationService signOutUser:^(bool status) {
        if (status) {
            //InitialViewController *initialVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failureBlock:^(bool status, NSError *error) {
       //TODO: show error alert
    }];
}

-(void)upDateUserFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email{
    
  __block  NSString * alertTitle = nil;
  __block   NSString * alertMessage = nil;
    
    [UserServices updateUserInfo:firstName lastName:lastName email:email success:^(bool status, NSString *message) {
        alertTitle = @"Success";
        alertMessage = message;
    } failure:^(bool status, NSError *error) {
        alertTitle = @"Failure";
        alertMessage = [error localizedDescription];
    }];
    if (alertTitle)
        [[[UIAlertView  alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil] show];
}

-(BOOL)isValidEmail:(NSString *)email{
    
    //TODO: create regix to validate
    return true;
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
