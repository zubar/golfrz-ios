//
//  RewardDescriptionViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/10/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RewardDescriptionViewController.h"
#import "Reward.h"

@interface RewardDescriptionViewController ()

@end

@implementation RewardDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.lblRewardName.text = [self.currentReward name];
    self.lblRewardPoints.text = [[self.currentReward pointsRequired] stringValue];
    self.lblRewardDetails.text = [self.currentReward rewardBreif];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    // Left nav-bar.
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(baseButtonTap) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.rewardViewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.rewardViewController.navigationItem.leftBarButtonItem = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnRedeemedTapped:(UIButton *)sender {


}

-(void)baseButtonTap{
    [self.rewardViewController cycleControllerToIndex:0];
}


@end
