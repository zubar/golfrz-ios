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
    // Do any additional setup after loading the view.
    //_parentScrollVIew.contentSize = CGSizeMake(320, 700);
//    _rightCollectionView.contentSize = CGSizeMake(320, 400);
 //   _leftCollectionView.contentSize = CGSizeMake(320, 700);
    [ScoreBoardManager sharedScoreBoardManager].numberOfItems = 18;
    [ScoreBoardManager sharedScoreBoardManager].numberOfSections = 100;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _leftCollectionView)
    {
     
        return 0;
    }
    return 18;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == _leftCollectionView)
    {
        return 0;
    }
    return 100;
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
