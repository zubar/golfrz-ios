//
//  ScoreBoardViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreBoardViewController.h"
#import "ScoreBoardManager.h"
#import "ScoreBoardParentCell.h"
#import "ScoreboardServices.h"
#import "ScoreCard.h"
#import "MBProgressHUD.h"
@interface ScoreBoardViewController ()

@end

@implementation ScoreBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [ScoreBoardManager sharedScoreBoardManager].numberOfSections = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [ScoreboardServices getScoreCard:^(bool status, id responseObject) {
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        ScoreCard *scoreCard = [[ScoreCard alloc] initWithDictionary:responseObject];
        
        [ScoreBoardManager sharedScoreBoardManager].numberOfItems = scoreCard.holesArray.count;
        [ScoreBoardManager sharedScoreBoardManager].numberOfSections = 100;
        
        [_rightCollectionView reloadData];

        
    } failure:^(bool status, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Failed");
    }];
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
    
    if (collectionView == _leftCollectionView) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParentCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UICollectionViewCell alloc]init];
        }
        ScoreBoardParentCell *customCell = (ScoreBoardParentCell *)cell;
//        if (indexPath.section == 0) {
//            //customCell.backgroundColor = [UIColor darkGrayColor];
//        }else{
//            //customCell.backgroundColor = [UIColor colorWithRed:63/255 green:63/255 blue:65/255 alpha:1];
//            customCell.backgroundColor = [UIColor darkGrayColor];
//        }
        return customCell;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rightParentCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UICollectionViewCell alloc]init];
    }
//    ScoreBoardParentCell *customCell = (ScoreBoardParentCell *)cell;
//    if (indexPath.section == 0) {
//        //customCell.backgroundColor = [UIColor darkGrayColor];
//    }else{
//        //customCell.backgroundColor = [UIColor colorWithRed:63/255 green:63/255 blue:65/255 alpha:1];
//        customCell.backgroundColor = [UIColor darkGrayColor];
//    }
    return cell;
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
