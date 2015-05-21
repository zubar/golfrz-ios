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
    ClubHouseContainerVC *clubHouseContainerVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubHouseContainerVC"];
    
    [self.navigationController pushViewController:clubHouseContainerVC animated:YES];
}
@end
