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

@interface RewardListViewController ()
@property (strong, nonatomic) NSMutableArray * rewardsList;
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
    
    
    
//    _dataSource.cellConfigureBlock = ^(SSBaseCollectionCell *cell,
//                                       id object,
//                                       UITableView *tableView,
//                                       NSIndexPath *indexPath) {
//        [cell configureCell:nil atIndex:indexPath withObject:object];
//        [cell setNeedsUpdateConstraints];
//        [cell updateConstraintsIfNeeded];
//    };
    
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
    UITableView *cell = [tableView dequeueReusableCellWithIdentifier:<#(NSString *)#>];
    if (cell == nil)
    {
        cell = [[UITableView alloc]init];
    }
    
    
    oodBevViewCell *customCell = (FoodBevViewCell *)cell;
    
    [customCell.lblItemName setText:food_bev_item.name];
    [customCell.lblItemPrice setText:food_bev_item.price.stringValue];
    return customCell;


}
@end











