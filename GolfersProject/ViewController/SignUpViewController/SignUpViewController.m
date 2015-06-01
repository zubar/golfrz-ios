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
    
    [AuthenticationService singUpUser:[self.txtFirstName text] lastName:[self.txtLastName text] email:[self.txtEmail text] password:[self.txtPassword text] passwordConfirmation:[self.txtPassword text] memberId:[self.txtMemberID text]completion:^(bool status, NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully registered" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        SignInViewController *signInVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
        
        [self.navigationController pushViewController:signInVC animated:YES];

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

#pragma TextFieldMethods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


@end
