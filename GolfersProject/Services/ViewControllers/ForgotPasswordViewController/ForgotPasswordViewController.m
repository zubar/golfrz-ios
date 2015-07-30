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
#import "SignInViewController.h"
#import "PlayerProfileViewController.h"
#import "ClubHouseContainerVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CourseServices.h"
#import "Course.h"
#import "SharedManager.h"
#import "UIImageView+RoundedImage.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view.
    
    // Setting course logo
    SharedManager * manager = [SharedManager sharedInstance];

    [self.imgCourseLogo sd_setImageWithURL:[NSURL URLWithString:manager.logoImagePath] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgCourseLogo setRoundedImage:image];
        }
    }];
    
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
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
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
    [delegate.appDelegateNavController popViewControllerAnimated:YES];
    
    
//    for (id controller in delegate.appDelegateNavController.viewControllers) {
//        if ([controller isKindOfClass:[ClubHouseContainerVC class]]) {
//            [self.navigationController popToAppDelegateNavController:controller animated:YES];
//            return;
//        }
//    }
}



- (NSString *)validateForm {
    NSString *errorMessage;
    NSString *emailRegex = @"[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  if (![emailPredicate evaluateWithObject:self.txtEmailAddress.text]){
      errorMessage = @"Please enter a valid email address";
        }
                return errorMessage;
            }



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


/*
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
*/
 @end
