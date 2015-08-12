//
//  RewardListViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RewardListViewController.h"
#import "GolfrzError.h"
#import "RewardServices.h"
#import "Utilities.h"
#import "RewardListCell.h"
#import "Reward.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RewardDescriptionViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface RewardListViewController ()
@property (strong, nonatomic) NSMutableArray * rewardsList;
@property (strong, nonatomic) Reward * selectedReward;

@end

@implementation RewardListViewController

#pragma Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    if(!self.rewardsList) self.rewardsList = [[NSMutableArray alloc]init];
}
#pragma Configure View

/**********
 ********** Configure current view **********
 **********/

- (void)configureView   {
    
    self.navigationItem.title = @"REWARDS";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self fetchRewardsListCompletion:^{
        [self.rewardTable reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API Calls

-(void)fetchRewardsListCompletion:(void(^)(void))completion
{
    [RewardServices getRewardsList:^(bool status, NSArray *rewardList) {
        if(status){
            if([self.rewardsList count] > 0) [self.rewardsList removeAllObjects];
            [self.rewardsList addObjectsFromArray:rewardList];
            completion();
        }
    } failure:^(bool status, GolfrzError *error) {
        completion();
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}
- (IBAction)btnViewRewardTap:(id)sender {
    
}

/**
 * TableViewDelegates
 */
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rewardsList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardListCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RewardListCell"];
    }
    
    Reward * reward = self.rewardsList[indexPath.row];
    RewardListCell *customCell = (RewardListCell *)cell;
    
    [customCell.lblRewardName setText:[reward name]];
    [customCell.lblPoints setText:[[reward pointsRequired] stringValue]];
    [customCell.imgRewardImage sd_setImageWithURL:[NSURL URLWithString:[reward imagePath]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [customCell.imgRewardImage setImage:image];
    }];
    
    customCell.currentReward = reward;
    [customCell setDelegate:self];
    return customCell;

}
- (IBAction)btnRewieRewardsTapped:(UIButton *)sender
{
    [self.rewardViewController cycleControllerToIndex:1];
}

- (void) btnRedeemTappedForCurrentCell:(Reward *)rewardItem{
    
    if (!self.rewardDescriptionViewController) {
        self.rewardDescriptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardDescriptionViewController"];
    }
    self.rewardDescriptionViewController.currentReward = rewardItem;
    self.selectedReward = rewardItem;
    [self.rewardViewController cycleControllerToIndex:2];
    
}

@end











