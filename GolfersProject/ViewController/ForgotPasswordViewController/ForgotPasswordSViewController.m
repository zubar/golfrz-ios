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
#import "AppDelegate.h"
#import "CourseServices.h"
#import "Course.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SharedManager.h"
#import "UIImageView+RoundedImage.h"


@interface ForgotPasswordSViewController ()

@end

@implementation ForgotPasswordSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];
    [self addGestureToSignIn];
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

-(void) addGestureToSignIn{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToLoginTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblBackToLogin setUserInteractionEnabled:YES];
    [self.lblBackToLogin addGestureRecognizer:gesture];
}

- (void)backToLoginTapped{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    
    for (UIViewController *controller in delegate.appDelegateNavController.viewControllers) {
        if ([controller isKindOfClass:[SignInViewController class]]) {
            [delegate.appDelegateNavController popToViewController:controller animated:YES];
            return;
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
