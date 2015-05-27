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
#import "Coordinates.h"
#import "Course.h"
#import "CalendarEventServices.h"

#import "FaceBookAuthAgent.h"


@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];

    //[self setImageCourseLogoRounded];
    [self addGestureToSignIn];
   
    
//    [AuthenticationService loginWithUserName:@"admin@golfrz.com" password:@"password" success:^(User * muser){
//        
//        NSLog(@"%@",[UserServices currentUser]);
//        [[[UIAlertView alloc]initWithTitle:@"Authenticated" message:muser.authToken delegate:nil cancelButtonTitle:@"Oky" otherButtonTitles:nil, nil] show];
//    }];
//    
    
    [CourseServices courseInfo:^(bool status, Course *currentCourse) {
        
        NSLog(@"%@", [[currentCourse.coordinates objectAtIndex:0] class]);
        
        if (status) {
            [WeatherServices weatherInfo:^(bool status, NSArray *mWeatherData) {
                NSLog(@"weather:%@", mWeatherData);
            } failure:^(bool status, NSError *error) {
                NSLog(@"%@", error);
            }];
        }
        
    } failure:^(bool status, NSError *error) {
        //
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* method to make the image rounded if not provided
-(void)setImageCourseLogoRounded{
    [self.imgCourseLogo.layer setCornerRadius:(CGRectGetWidth(self.imgCourseLogo.frame) / 2)];
    [self.imgCourseLogo setClipsToBounds:YES];
}
 */

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

- (IBAction)connectWithFacebook:(id)sender {

    [FaceBookAuthAgent signInWithFaceBook];

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
