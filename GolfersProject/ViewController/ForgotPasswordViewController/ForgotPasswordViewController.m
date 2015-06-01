//
//  ForgotPasswordViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/19/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ForgotPasswordSViewController.h"
#import "AuthenticationService.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "ClubHouseContainerVC.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


- (IBAction)btnResetPasswordTapped:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AuthenticationService resetUserPassword:self.txtEmailAddress.text completion:^(bool status){
        if (status) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ForgotPasswordSViewController *forgotPasswordSViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordSViewController"];
            [self.navigationController pushViewController:forgotPasswordSViewController animated:YES];

        }
    } failure:^(bool status, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Something went wrong" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] show];
    }];
       }

- (IBAction)backTapped:(id)sender {
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    for (id controller in delegate.appDelegateNavController.viewControllers) {
        if ([controller isKindOfClass:[ClubHouseContainerVC class]]) {
            [delegate.appDelegateNavController popToViewController:controller animated:YES];
            return;
        }
    }
}

@end
