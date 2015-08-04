//
//  ScoreBoardViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreBoardViewController.h"
#import "ScoreBoardManager.h"
#import "ScoreboardServices.h"
#import "ScoreCard.h"
#import "MBProgressHUD.h"
@interface ScoreBoardViewController (){
    
    NSUInteger numberOfLeftColumns;
}


@end

@implementation ScoreBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [ScoreBoardManager sharedScoreBoardManager].numberOfSections = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [ScoreboardServices getScoreCardForRoundId:[NSNumber numberWithInt:466] subCourse:[NSNumber numberWithInt:1] success:^(bool status, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        ScoreCard *scoreCard = [[ScoreCard alloc] initWithDictionary:responseObject];
        
        [ScoreBoardManager sharedScoreBoardManager].numberOfItems = (int)scoreCard.holesArray.count;
        [ScoreBoardManager sharedScoreBoardManager].numberOfSections = 100;
        [ScoreBoardManager sharedScoreBoardManager].scoreCard = scoreCard;
        
        [_rightCollectionView reloadData];
        

    } failure:^(bool status, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Failed");
    }];
    numberOfLeftColumns = [[ScoreBoardManager sharedScoreBoardManager].scoreCard.teeBoxCount intValue] + 2;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (collectionView == _leftCollectionView)
    {
     
        return 0;
    }
    return [ScoreBoardManager sharedScoreBoardManager].numberOfSections;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    if (collectionView == _leftCollectionView)
    {
        return 0;
    }
    return [ScoreBoardManager sharedScoreBoardManager].numberOfItems;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headerCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UICollectionViewCell alloc]init];
        }
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rightParentCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UICollectionViewCell alloc]init];
        }
    }
    
    
    if (indexPath.row > numberOfLeftColumns)
    {
        NSLog(@"Index-Path:%@ row:%ld  item:%ld", indexPath, (long)indexPath.row, (long)indexPath.item);
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftColorImage"]];
    }else{
        //cell.backgroundColor = [UIColor colorWithRed:51/255 green:52/255 blue:54/255 alpha:1];
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
