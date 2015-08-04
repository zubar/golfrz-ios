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
#import "InitialViewController.h"
#import "SharedManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+RoundedImage.h"
#import "Utilities.h"

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
    

    SharedManager * manager = [SharedManager sharedInstance];
    
    [self.imgCourseLogo sd_setImageWithURL:[NSURL URLWithString:manager.logoImagePath] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgCourseLogo setRoundedImage:image];
        }
    }];
    [self.lblCourseName setText:[manager courseName]];
    [self.lblCourseCityState setText:[NSString stringWithFormat:@"%@, %@", manager.courseCity, manager.courseState]];

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

-(void)viewWillAppear:(BOOL)animated{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:YES];
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
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    [Utilities checkInternetConnectivityWithAlertCompletion:^(bool status) {
        if(!status)
            return ;
    }];

    
    [AuthenticationService loginWithUserName:self.txtUsername.text password:self.txtPassword.text success:^(bool status, NSDictionary *muser){
        AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         ClubHouseContainerVC *clubHouseContainerVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubHouseContainerVC"];
        [delegate.appDelegateNavController pushViewController:clubHouseContainerVC animated:YES];
    } failure:^(bool status, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Credentials not valid" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] show];
    }];
   
}

-(NSString *)validateForm {
    NSString *errorMessage;
    
    NSString *emailRegex = @"[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    //TODO:
    //NSString *passwordRegex =@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //NSPredicate *pswdPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    
    if (!(self.txtUsername.text.length >= 1)){
        errorMessage = @"Please enter a valid e-mail address";
    }else
        if (![emailPredicate evaluateWithObject:self.txtUsername.text]){
            errorMessage = @"Please enter valid e-mail address";
        }
    else
           if (!(self.txtPassword.text.length >= 1) && [self.txtPassword.text containsString:@" "]){
                   errorMessage = @"Please enter valid password";
             }
    
    return errorMessage;
}



- (IBAction)btnBackTapped:(id)sender {
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    for (id controller  in [self.navigationController viewControllers]) {
        if ([controller isKindOfClass:[InitialViewController class]]) {
            [delegate.appDelegateNavController popViewControllerAnimated:YES];
        }
    }
}


@end
