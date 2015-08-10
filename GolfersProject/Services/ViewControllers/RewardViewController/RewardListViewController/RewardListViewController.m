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
    
    UITableView *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardListCell"];
    if (cell == nil)
    {
        cell = [[UITableView alloc]init];
    }
    
    Reward * reward = self.rewardsList[indexPath.row];
    RewardListCell *customCell = (RewardListCell *)cell;
    
    return customCell;

}
- (IBAction)btnRewieRewardsTapped:(UIButton *)sender {

}

//
//@property(copy, nonatomic, readonly) NSNumber * itemId;
//@property(copy, nonatomic, readonly) NSString * name;
//@property(copy, nonatomic, readonly) NSString * rewardDetail;
//@property(copy, nonatomic, readonly) NSNumber * pointsRequired;
//@property(copy, nonatomic, readonly) NSString * rewardBreif;
//@property(copy, nonatomic, readonly) NSString * imagePath;

@end











