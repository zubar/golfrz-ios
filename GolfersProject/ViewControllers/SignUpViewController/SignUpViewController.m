//
//  SignUpViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "SignUpViewController.h"
#import "InitialViewController.h"
#import "AuthenticationService.h"
#import "MBProgressHUD.h"
#import "CourseServices.h"
#import "AuthenticationService.h"
#import "UserServices.h"
#import "SignInViewController.h"
#import "ClubHouseContainerVC.h"
#import "AppDelegate.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma ButtonActions

- (IBAction)btnRegisterTapped:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    
    // calling signup service method
    [AuthenticationService singUpUser:[self.txtFirstName text]
                             lastName:[self.txtLastName text]
                                email:[self.txtEmail text]
                             password:[self.txtPassword text]
                 passwordConfirmation:[self.txtPassword text]
                             memberId:[self.txtMemberID text]
                             handicap:[self.txtHandicapNo text]
    completion:^(bool status, NSDictionary *userinfo) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
        ClubHouseContainerVC *clubHouseContainerVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubHouseContainerVC"];
        [delegate.appDelegateNavController pushViewController:clubHouseContainerVC animated:YES];
        

    } failure:^(bool status, NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Something went wrong" delegate:nil cancelButtonTitle:@"CANCEL" otherButtonTitles:nil, nil] show];
    }];
    
}

- (IBAction)btnBackTapped:(UIButton *)sender {
    //[self performSegueWithIdentifier:@"backToMainSegue" sender:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[InitialViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (NSString *)validateForm {
    NSString *errorMessage;
    
    NSString *emailRegex = @"[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    NSString *passwordRegex =@"^(?=.*\\d).{8,12}$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSPredicate *pswdPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    
    if (!(self.txtFirstName.text.length >= 1)){
        errorMessage = @"Please enter a first name";
    } else
        if (!(self.txtLastName.text.length >= 1)){
        errorMessage = @"Please enter a last name";
    } else
        if (![emailPredicate evaluateWithObject:self.txtEmail.text]){
        errorMessage = @"Please enter a valid email address";
    } else
        if (![pswdPredicate evaluateWithObject:self.txtPassword.text]){
        errorMessage = @"Password must be between 8 and 12 digits long and include at least one numeric digit.";
    }
    
    return errorMessage;
}

#pragma TextFieldMethods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


@end
