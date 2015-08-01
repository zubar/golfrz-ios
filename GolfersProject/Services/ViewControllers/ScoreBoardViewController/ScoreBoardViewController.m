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

@interface ScoreBoardViewController ()

@end

@implementation ScoreBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ScoreBoardManager sharedScoreBoardManager].numberOfItems = 18;
    [ScoreBoardManager sharedScoreBoardManager].numberOfSections = 100;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return 12;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 18;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rightParentCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UICollectionViewCell alloc]init];
    }
    
    if (indexPath.row > 5)
    {
        NSLog(@"Index-Path:%@ row:%ld  item:%ld", indexPath, (long)indexPath.row, (long)indexPath.item);
        cell.backgroundColor = [UIColor lightGrayColor];
    }else{
        cell.backgroundColor = [UIColor blackColor];
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
