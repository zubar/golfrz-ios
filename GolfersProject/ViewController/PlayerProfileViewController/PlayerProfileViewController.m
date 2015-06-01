//
//  BlueViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PlayerProfileViewController.h"
#import "ClubHouseContainerVC.h"

#import "UserServices.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "CourseServices.h"
#import "Course.h"

@interface PlayerProfileViewController ()

@end

@implementation PlayerProfileViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[self navigationItem] setTitle:@"PLAYERPROFILE"];
    UIButton * imageRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 22, 22)];
    [imageRightButton setBackgroundImage:[UIImage imageNamed:@"invite_icon"] forState:UIControlStateNormal];
    [imageRightButton addTarget:self action:@selector(test) forControlEvents:UIControlEventAllEvents];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageRightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [UserServices getUserInfo:^(bool status, User *mUser) {
        
        [self.lblUserName setText:mUser.firstName];
        [self.lblHandicap setText:@"0"];
        //TODO: add pints in service 
        [self.lblPoints setText:@"0"];
        [self.lblCourseName setText:[[CourseServices currentCourse] courseName]];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(bool status, NSError *error) {
        //TODO: add in a separate file all the alert messages.
        [[[UIAlertView alloc] initWithTitle:@"Failure" message:@"Failed to get details" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil] show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}

- (void)pushNextController{
        [self.navigationController pushViewController:self.containerVC.rewardViewController animated:YES];
}

- (void) test {
}

-(void)popToPreviousController{
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavBarButtonsDelegate

//-(NSDictionary *)updateNavBarRightButtons{
//    
//    UIButton * barBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, 30)];
//    [barBtn setTitle:@"Flop" forState:UIControlStateNormal];
//    [barBtn addTarget:self action:@selector(btnTapped) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:barBtn, @"left_btn",nil];
//    return dict;
//}
//

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSettingsTapped:(UIButton *)sender {
}
- (IBAction)btnStartRoundTapped:(UIButton *)sender {
}
@end
