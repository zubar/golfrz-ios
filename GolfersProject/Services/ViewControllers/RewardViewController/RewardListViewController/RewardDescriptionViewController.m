//
//  RewardDescriptionViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/10/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RewardDescriptionViewController.h"
#import "Reward.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RewardServices.h"
#import "GolfrzError.h"
#import "Utilities.h"
#import "Constants.h"

@interface RewardDescriptionViewController ()

@end

@implementation RewardDescriptionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.view setHidden:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Left nav-bar.
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(baseButtonTap) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.rewardViewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [self updateUserPoints];
    
    [self.rewardImage sd_setImageWithURL:[NSURL URLWithString:[self.currentReward imagePath]] placeholderImage:nil  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.rewardImage setImage:image];
        }
    }];
    self.lblRewardName.text = [self.currentReward name];
    self.lblRewardPoints.text = [[self.currentReward pointsRequired] stringValue];
    self.lblRewardDetails.text = [self.currentReward rewardDetail];
    // Do any additional setup after loading the view.
}

- (void)updateUserPoints
{
    [RewardServices getUserRewardPoints:^(bool status, NSNumber *totalPoints) {
        if(status){
            NSInteger userPoints = [totalPoints integerValue];
            NSInteger remainingPoints = [[self.currentReward pointsRequired] integerValue] - userPoints;
            if(remainingPoints > 0){
                [self.rewardNotRedeemedView setHidden:NO];
                [self.btnRedeem setHidden:YES];
                [self.lblPointsRequired setText:[NSString stringWithFormat:@"%ld", (long)remainingPoints]];
            }else{
                [self.rewardNotRedeemedView setHidden:YES];
                [self.btnRedeem setHidden:NO];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(bool status, GolfrzError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.view setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.rewardViewController.navigationItem.leftBarButtonItem = nil;
}

- (IBAction)btnRedeemedTapped:(UIButton *)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RewardServices redeemRewardWithId:[self.currentReward itemId] success:^(bool status, id response) {
        if(status){
            // Observer of this notification is RewardViewController which updates its label of total reward points of user.
            [[NSNotificationCenter defaultCenter] postNotificationName:kRedeemedReward object:nil];
            
             [[[UIAlertView alloc] initWithTitle:@"REWARD REDEEMED" message:@"Congratulations! An email will be sent shortly your way with more details." delegate:self cancelButtonTitle:@"BACK TO APP" otherButtonTitles:@"CHECK EMAIL", nil] show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self updateUserPoints];
        }
    } failure:^(bool status, GolfrzError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}

-(void)baseButtonTap{
    [self.rewardViewController cycleControllerToIndex:0];
}


#pragma  - mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // In case user clicked on CHECK EMAIL button.
    if(buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.gmail.com"]];
    }
}

@end
