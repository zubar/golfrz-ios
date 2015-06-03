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
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface PlayerSettingsMainViewController ()

@end

@implementation PlayerSettingsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Assuming the view will always be created in non-editing mode.
    isEditing = false;
    
    
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(backBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
  
    self.navigationItem.title = @"Settings";
    
    [self addGestureToEditProfile];
    [self addGestureToLogout];
    [self addGestureToResetPassword];
}
-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    
    [self loadUserInfo];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:YES];


}

-(void)loadUserInfo{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [UserServices getUserInfo:^(bool status, User *userInfo) {
        if (status) {
            User * mUser = userInfo;
                [self.txtFirstName setText:[mUser firstName]];
                [self.txtLastName setText:[mUser firstName]];
                [self.txtEmailAddress setText:[mUser email]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(bool status, NSError *error) {
        //
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Failure====================================================================================");
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnTapped{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController popViewControllerAnimated:YES];
    
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
   
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    
    ForgotPasswordViewController *forgetPasswordVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [delegate.appDelegateNavController pushViewController:forgetPasswordVC animated:YES];
    
}

- (void)logoutTapped {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [AuthenticationService signOutUser:^(bool status) {
        if (status) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[[UIAlertView alloc]initWithTitle:@"Success" message:@"Please check your email to confirm " delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Okay Comment") otherButtonTitles:nil, nil] show];
        }
    } failureBlock:^(bool status, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Something went wrong" delegate:nil cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Okay Comment") otherButtonTitles:nil, nil] show];
        
        
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
