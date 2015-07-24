//
//  ScoreBoardViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreBoardViewController.h"
#import "ScoreBoardParentCell.h"

@interface ScoreBoardViewController ()

@end

@implementation ScoreBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParentCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UICollectionViewCell alloc]init];
    }
    ScoreBoardParentCell *customCell = (ScoreBoardParentCell *)cell;
    if (indexPath.section == 0) {
        //customCell.backgroundColor = [UIColor darkGrayColor];
    }else{
        //customCell.backgroundColor = [UIColor colorWithRed:63/255 green:63/255 blue:65/255 alpha:1];
        customCell.backgroundColor = [UIColor darkGrayColor];
    }
    return customCell;
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
