//
//  BlueViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PlayerProfileViewController.h"
#import "ClubHouseContainerVC.h"

@interface PlayerProfileViewController ()

@end

@implementation PlayerProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)pushNextController{
        [self.navigationController pushViewController:self.containerVC.rewardViewController animated:YES];
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
