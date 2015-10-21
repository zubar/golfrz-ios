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
#import "SignInViewController.h"
#import "ClubHouseContainerVC.h"
#import "WelcomeViewController.h"

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
        Course * mCourse = tObject;
        // Setting ThemeColor
        UIColor * themeColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"0x%@", [mCourse courseTheme]]];
        (themeColor != nil ? [sharedManager setThemeColor:themeColor] : [sharedManager setThemeColor:[UIColor colorWithHexString:kDefaultThemeColor]]);
        // Setting
        [sharedManager setCourseCity:[mCourse courseCity]];
        [sharedManager setCourseName:[mCourse courseName]];
        [sharedManager setCourseState:[mCourse courseState]];
        [sharedManager setLogoImagePath:[mCourse courseLogo]];
        [sharedManager setBackgroundImagePath:[mCourse courseBackgroundImage]];
        
        self.navigationController.navigationBar.barTintColor = [[SharedManager sharedInstance] themeColor];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        
        [self loadBackgroundImageFromUrl:[sharedManager backgroundImagePath]];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        // If user has already signed in and token is available.
    
        if ([UserServices currentToken] != nil)
        {
            InitialViewController * initController = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
            AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
            UIViewController *clubHouseContainerVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubHouseContainerVC"];
            [delegate.appDelegateNavController pushViewController:initController animated:NO];
            [delegate.appDelegateNavController pushViewController:clubHouseContainerVC animated:NO];
        }else{
            // push sign in controller
            WelcomeViewController * initController = [self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
            [delegate.appDelegateNavController pushViewController:initController animated:YES];
        }
    } failure:^(bool status, NSError * error)
    {
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

        // push sign in controller
        WelcomeViewController * initController = [self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
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
