//
//  InitialViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "InitialViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SignInViewController.h"

#import "AuthenticationService.h"


@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];
    [self setImageCourseLogoRounded];
    [self addGestureToSignIn];
    
    
    [AuthenticationService loginWithUserName:@"its my name" password:@"Abdullah"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setImageCourseLogoRounded{
    [self.imgCourseLogo.layer setCornerRadius:(CGRectGetWidth(self.imgCourseLogo.frame) / 2)];
    [self.imgCourseLogo setClipsToBounds:YES];
}

-(void) addGestureToSignIn{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signInTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblSignIn setUserInteractionEnabled:YES];
    [self.lblSignIn addGestureRecognizer:gesture];
}

- (void)signInTapped{
    SignInViewController *signInViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self.navigationController pushViewController:signInViewController animated:YES];
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
