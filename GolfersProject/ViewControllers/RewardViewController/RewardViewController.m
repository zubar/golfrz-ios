//
//  GrayViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RewardViewController.h"
#import "ClubHouseContainerVC.h"

@interface RewardViewController ()

@end

@implementation RewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)popToPreviousController{
        [self.navigationController popViewControllerAnimated:YES];
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
