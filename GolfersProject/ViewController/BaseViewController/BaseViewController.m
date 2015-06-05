//
//  BaseViewController.m
//  GolfersProject
//
//  Created by Zubair on 6/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "SharedManager.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:0.0 forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [[SharedManager sharedInstance] themeColor];

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
