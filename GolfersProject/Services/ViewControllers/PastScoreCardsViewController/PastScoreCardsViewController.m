//
//  PastScoreCardsViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/10/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PastScoreCardsViewController.h"
#import "PastScoreCardCell.h"
#import "ScoreboardServices.h"
#import "PastScore.h"
#import "Utilities.h"
#import "MBProgressHUD.h"
#import "ScoreBoardViewController.h"

@interface PastScoreCardsViewController ()
@property(strong, nonatomic) NSMutableArray * pastScores;
@end

@implementation PastScoreCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"PAST SCORECARDS";
    // Do any additional setup after loading the view.
    if(!self.pastScores) self.pastScores = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ScoreboardServices getScorecardHistory:^(bool status, NSArray *enabledFeatures)
    {
        if([self.pastScores count] > 0)[self.pastScores removeAllObjects];
        [self.pastScores addObjectsFromArray:enabledFeatures];
        [self.scoreCardTable reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(bool status, GolfrzError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.pastScores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"PastScoreCardCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PastScoreCardCell"];
    }
    
    PastScore * mPastScore = self.pastScores[indexPath.row];
    
    PastScoreCardCell *customViewCell = (PastScoreCardCell *)customCell;
    [Utilities dateComponents:[mPastScore createdAt] components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute, NSString *year)
    {
        [customViewCell.lblDayDate setText:[NSString stringWithFormat:@"%@ %@", monthName, day]];
        [customViewCell.lblYear setText:year];

    }];
    [customViewCell.lblGameType setText:[mPastScore gameType]];
    [customViewCell.lblScore setText:[[mPastScore grossScore] stringValue]];
    [customViewCell.lblScoreCardIdentifier setText:[[mPastScore subCourseName] uppercaseString]];
    return customViewCell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    PastScore * mPastScore = self.pastScores[indexPath.row];
    
    ScoreBoardViewController *scoreBoardVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SCORE_BOARD_VC_ID"];
    scoreBoardVc.roundId = [mPastScore roundId];
    scoreBoardVc.subCourseId = [mPastScore subCourseId];
    [self.navigationController pushViewController:scoreBoardVc animated:YES];
}

@end
