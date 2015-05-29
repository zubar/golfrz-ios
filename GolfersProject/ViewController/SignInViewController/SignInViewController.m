//
//  SignInViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/15/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "SignInViewController.h"
#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"
#import "ClubHouseContainerVC.h"
#import "AuthenticationService.h"
#import "User.h"
#import "MBProgressHUD.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //[super viewWillAppear:YES];
    [self addGestureToForgotPassword];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addGestureToForgotPassword{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPasswordTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblForgotPassword setUserInteractionEnabled:YES];
    [self.lblForgotPassword addGestureRecognizer:gesture];
}

- (void)forgotPasswordTapped{
    ForgotPasswordViewController *forgotPasswordViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    
    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSignInTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AuthenticationService loginWithUserName:self.txtUsername.text password:self.txtPassword.text success:^(bool status, Auth *muser){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         ClubHouseContainerVC *clubHouseContainerVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubHouseContainerVC"];
        [self.navigationController pushViewController:clubHouseContainerVC animated:YES];
        [[[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully logged in" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    } failure:^(bool status, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc]initWithTitle:@"Credentials Not Valid" message:@"Credentials not valid" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] show];
    }];
    
//    [AuthenticationService loginWithUserName:self.txtUsername.text password:self.txtPassword.text success:^(bool status, User *muser){
//        
//            ClubHouseContainerVC *clubHouseContainerVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubHouseContainerVC"];
//            
//            [self.navigationController pushViewController:clubHouseContainerVC animated:YES];
//        [[[UIAlertView alloc]initWithTitle:@"Authenticated" message:@"You have successfully logged in" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
//    }
//                                     failure:^(bool status, NSError *error){
//                                         [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Credentials not valid" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] show];
//                                     }
//     
//    ];
   
}
@end
