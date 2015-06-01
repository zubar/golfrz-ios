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
#import "SignInViewController.h"
#import "PlayerProfileViewController.h"
#import "ClubHouseContainerVC.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
- (IBAction)btnBackButtonTapped:(UIButton *)sender {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[SignInViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }else if ([controller isKindOfClass:[PlayerProfileViewController class]])
        {
             [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
}
@end
