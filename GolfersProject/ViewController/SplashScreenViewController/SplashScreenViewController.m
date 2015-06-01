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


@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self.imgSplash setImage:[UIImage imageNamed:@"background_image"]];

    SharedManager * sharedManager = [SharedManager sharedInstance];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [CourseServices courseInfo:^(bool status, Course *currentCourse) {
            Course * mCourse = currentCourse;
        // Setting ThemeColor
            UIColor * themeColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"0x%@", mCourse.courseTheme]];
            (themeColor != nil ? [sharedManager setThemeColor:themeColor] : [sharedManager setThemeColor:[UIColor colorWithHexString:kDefaultThemeColor]]);
        // Setting 
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        InitialViewController * initController = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
        [self.navigationController pushViewController:initController animated:YES];
        
    } failure:^(bool status, NSError *error) {
        // Setting theme color
        [sharedManager setThemeColor:[UIColor colorWithHexString:kDefaultThemeColor]];
        //TODO:
        // Setting Background Image
        // Setting Course Logo
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        InitialViewController * initController = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
        [self.navigationController pushViewController:initController animated:YES];
    }];
    
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
