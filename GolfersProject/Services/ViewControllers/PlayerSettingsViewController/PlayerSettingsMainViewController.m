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
#import "SignInViewController.h"
#import "GolfrzError.h"
#import "Utilities.h"
#import "FaceBookAuthAgent.h"

@interface PlayerSettingsMainViewController ()

@end

@implementation PlayerSettingsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.backgroundImg setImage:[manager backgroundImage]];

    
    //Assuming the view will always be created in non-editing mode.
    isEditing = false;
    
    
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(playerSettingBackBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
  
    self.navigationItem.title = @"SETTINGS";
    [self addGestureToEditProfile];
        
    NSDictionary *titleAttributes =@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                     NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:12.0],
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    
    NSDictionary *navTitleAttributes =@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                     NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.0],
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    NSAttributedString * saveTitle  = [[NSAttributedString alloc] initWithString:@"EDIT PROFILE" attributes:titleAttributes];
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;

    [self.lblEditProfile setAttributedText:saveTitle];

}
-(void)viewWillAppear:(BOOL)animated{
    
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:0.0 forBarMetrics:UIBarMetricsDefault];
    
    [self loadUserInfo];
    [self makeUserInfoFieldsEditable:NO];
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
                [self.txtLastName setText:[mUser lastName]];
                [self.txtEmailAddress setText:[mUser email]];
                [self.txtPhoneNumber setText:[mUser phone]];
                [self makeUserInfoFieldsEditable:NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(bool status, GolfrzError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)playerSettingBackBtnTapped{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController popViewControllerAnimated:YES];
}

-(void) addGestureToEditProfile{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editProfileTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblEditProfile setUserInteractionEnabled:YES];
    [self.lblEditProfile addGestureRecognizer:gesture];
}

- (void) editProfileTapped{
    
    NSDictionary *titleAttributes =@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                     NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:12.0],
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    NSAttributedString * saveTitle = nil;
    
    if (!isEditing) {
        isEditing = true;
        saveTitle  = [[NSAttributedString alloc] initWithString:@"SAVE PROFILE" attributes:titleAttributes];
        [self.txtFirstName becomeFirstResponder];
    }else{
        isEditing = false;
        saveTitle = [[NSAttributedString alloc] initWithString:@"EDIT PROFILE" attributes:titleAttributes];
        [self.txtFirstName resignFirstResponder];
        [self.txtLastName resignFirstResponder];
        [self.txtEmailAddress resignFirstResponder];
        [self.txtPhoneNumber resignFirstResponder];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *errorMessage = [self validateForm];
        if (errorMessage) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            return;
        }
        [self upDateUserFirstName:[self.txtFirstName text] lastName:[self.txtLastName text] email:[self.txtEmailAddress text] phoneNo:[self.txtPhoneNumber text]];
    }
    
    [self.lblEditProfile setAttributedText:saveTitle];
    [self makeUserInfoFieldsEditable:isEditing];
}


- (NSString *)validateForm {
    NSString *errorMessage;
    
    NSString *emailRegex = @"[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (!(self.txtFirstName.text.length >= 1)){
        errorMessage = @"Please enter a first name";
    } else
        if (!(self.txtLastName.text.length >= 1)){
            errorMessage = @"Please enter a last name";
        } else
            if (![emailPredicate evaluateWithObject:self.txtEmailAddress.text]){
                errorMessage = @"Please enter a valid email address";
            }
    return errorMessage;
}

-(void)makeUserInfoFieldsEditable:(BOOL)yesNo{
    [self.txtFirstName setEnabled:yesNo];
    [self.txtLastName setEnabled:yesNo];
    [self.txtEmailAddress setEnabled:yesNo];
    [self.txtPhoneNumber setEnabled:yesNo];
}


- (IBAction)btnResetPasswordTap:(id)sender {
   
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    ForgotPasswordViewController *forgetPasswordVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [delegate.appDelegateNavController pushViewController:forgetPasswordVC animated:YES];
}

- (void)logoutTapped {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AuthenticationService signOutUser:^(bool status) {
        if (status) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self popToSignInViewController];
        }
    } failureBlock:^(bool status, GolfrzError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}
- (IBAction)btnLogOutTap:(id)sender {
    [self logoutTapped];
}
- (IBAction)btnDisConnectFacebookTap:(id)sender {
    
    [FaceBookAuthAgent disConnectFBAccount];
}

-(void)popToSignInViewController{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    
    for (UIViewController *controller in delegate.appDelegateNavController.viewControllers) {
        if ([controller isKindOfClass:[SignInViewController class]]) {
            [delegate.appDelegateNavController popToViewController:controller animated:YES];
            return;
        }
    }
}

-(void)upDateUserFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email phoneNo:(NSString *)phoneNo{
    
  __block  NSString * alertTitle = nil;
  __block  NSString * alertMessage = nil;
    
    [UserServices updateUserInfo:firstName lastName:lastName email:email phoneNo:phoneNo success:^(bool status, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        alertTitle = @"Success";
        alertMessage = message;
        if (alertTitle)
            [[[UIAlertView  alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}

-(BOOL)isValidEmail:(NSString *)email{
    
    NSString *emailRegex = @"[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (![emailPredicate evaluateWithObject:self.txtEmailAddress.text]){
        return false;//errorMessage = @"Please enter a valid email address";
    }else
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
    return YES;
}



@end
