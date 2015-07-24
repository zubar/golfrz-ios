//
//  ScoreBoardParentCell.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/24/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreBoardParentCell.h"

@implementation ScoreBoardParentCell
-(void)awakeFromNib
{
    collectionView_.delegate = self;
    collectionView_.dataSource = self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScoreCellId" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UICollectionViewCell alloc]init];
    }
//    UICollectionView *customCell = (ScoreBoardParentCell *)cell;
    return cell;
}
@end
