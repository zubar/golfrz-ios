//
//  ScoreBoardViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreBoardViewController.h"
#import "ScoreBoardManager.h"
#import "ScoreCardUser.h"
#import "ScoreCardUserScore.h"
#import "ScoreCardHole.h"
#import "ScoreboardServices.h"
#import "ScoreCard.h"
#import "ScoreBoardBodyCell.h"
#import "ScoreBoardHeaderCell.h"
#import "MBProgressHUD.h"
@interface ScoreBoardViewController (){
    
    NSUInteger numberOfLeftColumns;
    ScoreCard *scoreCard_;
}


@end

@implementation ScoreBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [ScoreBoardManager sharedScoreBoardManager].numberOfSections = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
//    [ScoreboardServices getScoreCardForRoundId:[NSNumber numberWithInt:466] subCourse:[NSNumber numberWithInt:1] success:^(bool status, id responseObject) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        scoreCard_ = [[ScoreCard alloc] initWithDictionary:responseObject];
//        
//        [ScoreBoardManager sharedScoreBoardManager].numberOfItems = scoreCard_.users.count + [scoreCard_.teeBoxCount intValue]+9;//(int)scoreCard.holesArray.count;
//        [ScoreBoardManager sharedScoreBoardManager].numberOfSections = 18;
//        [ScoreBoardManager sharedScoreBoardManager].scoreCard = scoreCard_;
//        
//        [_rightCollectionView reloadData];
//        
//
//    } failure:^(bool status, NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"Failed");
//    }];
    
    [ScoreboardServices getTestScoreCard:^(bool status, id responseObject) {
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        scoreCard_ = [[ScoreCard alloc] initWithDictionary:responseObject];
        
        [ScoreBoardManager sharedScoreBoardManager].numberOfItems = (int)scoreCard_.users.count + [scoreCard_.teeBoxCount intValue]+9;//(int)scoreCard.holesArray.count;
        [ScoreBoardManager sharedScoreBoardManager].numberOfSections = (int)scoreCard_.holeCount+1;
        [ScoreBoardManager sharedScoreBoardManager].scoreCard = scoreCard_;
        
        [_rightCollectionView reloadData];
        
    } failure:^(bool status, NSError *error) {
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    numberOfLeftColumns = [[ScoreBoardManager sharedScoreBoardManager].scoreCard.teeBoxCount intValue] + 2;

}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (collectionView == _leftCollectionView)
    {
     
        return 0;
    }
    return [ScoreBoardManager sharedScoreBoardManager].numberOfItems;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    if (collectionView == _leftCollectionView)
    {
        return 0;
    }
    return [ScoreBoardManager sharedScoreBoardManager].numberOfSections;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headerCell" forIndexPath:indexPath];
        ScoreBoardHeaderCell *headerCell = (ScoreBoardHeaderCell *)cell;
        if (cell == nil)
        {
            cell = [[UICollectionViewCell alloc]init];
        }
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftColorImage"]];
        if (indexPath.row == 0) {
            headerCell.lblHeading.text = @"Hole";
            UILabel *noLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 10, 10)];
            noLbl.text = @"#";
            [noLbl setFont:[UIFont fontWithName:@"System" size:9]];
            [noLbl setTextColor:[UIColor whiteColor]];
            [headerCell addSubview:noLbl];
            
        }
        
        else if (indexPath.row >1 && indexPath.row <= numberOfLeftColumns)
        {
            headerCell.lblHeading.text = @"HCP";
        }
        else if(indexPath.row > numberOfLeftColumns){
            int userIndex = indexPath.row - numberOfLeftColumns - 1;
            if (userIndex < scoreCard_.users.count) {
                ScoreCardUser *user = [scoreCard_.users objectAtIndex:userIndex];
                headerCell.lblHeading.text = user.firstName;
            }
            
            
        }
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rightParentCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UICollectionViewCell alloc]init];
        }
        ScoreBoardBodyCell *bodyCell = (ScoreBoardBodyCell *)cell;
        if (indexPath.row == 0) {
            
            ScoreCardHole *hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];
            if (hole) {
                
                bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",[hole.holeNumber intValue]];
            }
        }
        else if (indexPath.row == 1)
        {
            ScoreCardHole *hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];
            if (hole) {
                
                bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",[hole.parValue intValue]];
            }
        }
    }
    
    
    if (indexPath.row > numberOfLeftColumns && indexPath.section != 0)
    {
        
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftColorImage"]];
        ScoreBoardBodyCell *bodyCell = (ScoreBoardBodyCell *)cell;
        int index = (int)indexPath.row - (int)numberOfLeftColumns - 1;
        ScoreCardHole *hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];
        
        if (index < hole.scoreUsers.count) {
            
            ScoreCardUserScore *scoreUser = [hole.scoreUsers objectAtIndex:index];
            bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",[scoreUser.score intValue]];
        }
        
        
//        if ([user.userId isEqualToNumber:hole.userId]) {
//  
//        }
        
    }else{
        
        
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rightColorImage"]];
    }
    if (indexPath.section == 10) {
        
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rightColorImage"]];
    }

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Clicked");
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
