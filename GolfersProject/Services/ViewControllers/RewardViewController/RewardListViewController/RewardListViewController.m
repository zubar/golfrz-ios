//
//  RewardListViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RewardListViewController.h"

@interface RewardListViewController ()

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
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"RewardListCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RewardListCell"];
    }
    
    //CourseDepartmentCell *customViewCell = (CourseDepartmentCell *)customCell;
    
    
    
   
    return customCell;
}





/**********
 ********** Reload collection view data. **********
 **********/

//- (void)reloadChildViewContent:(NSMutableArray *)object  {
//    if (object != nil) {
//        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.availability == %@",[NSNumber numberWithInteger:1]];
//        [self.dataSource updateItems:[object filteredArrayUsingPredicate:predicate]];
//    }
//    [self.collectionView reloadData];
//}

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

/**********
 ********** remove currently displaying table view with flip animation. **********
 **********/

- (void)hideCurrentTable:(NSTimer *)timer {
//    CollectionTableCell *cell = timer.userInfo;
//    [cell hideContentTableView:YES];
//    cell.delegate = nil;
    [timer invalidate];
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

- (IBAction)btnRewieRewardsTapped:(UIButton *)sender {
}
@end
