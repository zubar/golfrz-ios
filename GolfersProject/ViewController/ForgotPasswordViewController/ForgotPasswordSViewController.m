//
//  ForgotPasswordSViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/21/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ForgotPasswordSViewController.h"
#import "SignInViewController.h"
#import "ClubHouseContainerVC.h"

@interface ForgotPasswordSViewController ()

@end

@implementation ForgotPasswordSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];
    [self addGestureToSignIn];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addGestureToSignIn{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToLoginTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblBackToLogin setUserInteractionEnabled:YES];
    [self.lblBackToLogin addGestureRecognizer:gesture];
}

- (void)backToLoginTapped{
    
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[SignInViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }else{
            SignInViewController *signInVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
            [self.navigationController pushViewController:signInVC animated:YES];

        }
    }

    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
