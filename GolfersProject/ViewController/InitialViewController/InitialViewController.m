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

#import "User.h"
#import "AuthenticationService.h"
#import "UserServices.h"
#import "CourseServices.h"
#import "WeatherServices.h"
#import "Coordinate.h"
#import "Course.h"
#import "CalendarEventServices.h"

#import "FaceBookAuthAgent.h"
#import "CalendarEventServices.h"
#import "EventList.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+RoundedImage.h"
#import "SharedManager.h"
#import "UIImageView+RoundedImage.h"
#import "FoodBeverageServices.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"


@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];

    [self addGestureToSignIn];
    
    SharedManager * manager = [SharedManager sharedInstance];
    
    [self.imgCourseLogo sd_setImageWithURL:[NSURL URLWithString:manager.logoImagePath] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgCourseLogo setRoundedImage:image];
        }
    }];
    [self.lblCourseName setText:[manager courseName]];
    [self.lblCityState setText:[NSString stringWithFormat:@"%@, %@", manager.courseCity, manager.courseState]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addGestureToSignIn{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signInTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblSignIn setUserInteractionEnabled:YES];
    [self.lblSignIn addGestureRecognizer:gesture];
    
}

- (void)signInTapped{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    SignInViewController *signInViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [delegate.appDelegateNavController pushViewController:signInViewController animated:YES];
}

- (IBAction)connectWithFacebook:(id)sender {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FaceBookAuthAgent signInWithFacebook:^(bool status, NSDictionary *userInfo) {
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
        ClubHouseContainerVC *clubHouseContainerVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubHouseContainerVC"];
        [delegate.appDelegateNavController pushViewController:clubHouseContainerVC animated:YES];
    } failure:^(bool status, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

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
