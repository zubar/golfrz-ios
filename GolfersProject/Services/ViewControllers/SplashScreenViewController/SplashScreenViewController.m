//
//  SplashScreenViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/1/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "Course.h"
#import "CourseServices.h"
#import "AppDelegate.h"
#import "UIColor+expanded.h"
#import "Constants.h"
#import "SharedManager.h"
#import "MBProgressHUD.h"
#import "InitialViewController.h"
#import "AppDelegate.h"
#import "SharedManager.h"
#import "User.h"

#import "UserServices.h"
#import "ClubHouseViewController.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[SharedManager sharedInstance] setBackgroundImage:[UIImage imageNamed:@"background_image"]];

    
    [self.imgSplash setImage:[[SharedManager sharedInstance] backgroundImage]];
    

    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    SharedManager * sharedManager = [SharedManager sharedInstance];
    
    [CourseServices courseInfo:^(bool status, id tObject) {
        NSDictionary * mCourse = tObject;
        // Setting ThemeColor
        UIColor * themeColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"0x%@", mCourse[@"course_theme"]]];
        (themeColor != nil ? [sharedManager setThemeColor:themeColor] : [sharedManager setThemeColor:[UIColor colorWithHexString:kDefaultThemeColor]]);
        // Setting
        [sharedManager setCourseCity:mCourse[@"course_city"]];
        [sharedManager setCourseName:mCourse[@"course_name"]];
        [sharedManager setCourseState:mCourse[@"course_state"]];
        [sharedManager setLogoImagePath:[NSString stringWithFormat:@"%@%@", kBaseImageUrl, mCourse[@"course_logo"]]];
        [sharedManager setBackgroundImagePath:[NSString stringWithFormat:@"%@%@", kBaseImageUrl, mCourse[@"course_bg_image"]]];
        
        self.navigationController.navigationBar.barTintColor = [[SharedManager sharedInstance] themeColor];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        
        [self loadBackgroundImageFromUrl:[sharedManager backgroundImagePath]];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        // If user has already signed in and token is available.
        /*
        if ([UserServices currentToken] != nil) {
            ClubHouseViewController * clubHouseController = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubHouseViewController"];
            [delegate.appDelegateNavController pushViewController:clubHouseController animated:YES];
        }else
        */{
            // push sign in controller
            InitialViewController * initController = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
            [delegate.appDelegateNavController pushViewController:initController animated:YES];
        }
    } failure:^(bool status, NSError * error) {
        
        [Utilities checkInternetConnectivityWithAlertCompletion:^(bool status) {
            if(!status)
                return ;
        }];
        // Setting theme color
        [sharedManager setThemeColor:[UIColor colorWithHexString:kDefaultThemeColor]];
        self.navigationController.navigationBar.barTintColor = [[SharedManager sharedInstance] themeColor];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];


        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        self.navigationController.navigationBar.barTintColor = [[SharedManager sharedInstance] themeColor];

        
        InitialViewController * initController = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
        [delegate.appDelegateNavController pushViewController:initController animated:YES];
    }];

}


-(void)loadBackgroundImageFromUrl:(NSString *)imagePath
{
     NSURL *url = [NSURL URLWithString:imagePath];
     NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
     NSURLResponse *response = nil;
     NSError *error = nil;
     
     NSLog(@"Firing synchronous url connection...");
     NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
     returningResponse:&response
     error:&error];
     
     if ([data length] > 0 && error == nil){
     UIImage * bgImag = [UIImage imageWithData:data];
     if (bgImag != nil) {
     [[SharedManager sharedInstance] setBackgroundImage:bgImag];
     }else{
     [[SharedManager sharedInstance] setBackgroundImage:[UIImage imageNamed:@"background_image"]];
     }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
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

@end
