//
//  ScoreSelectionView.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreSelectionView.h"
#import "ScoreSelectionCell.h"

@interface ScoreSelectionView (private){
  
}
@property (nonatomic, strong) NSMutableArray *scoresArray;
@end

@implementation ScoreSelectionView

- (id)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ScoreSelectionView class]) owner:self options:nil] firstObject];
        [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSelectionCellView" bundle:nil] forCellWithReuseIdentifier:@"ScoreSelectionCell"];
    }
    if (!self.scoresArray){
        self.scoresArray = [[NSMutableArray alloc]initWithCapacity:1];
        [self.scoresArray addObjectsFromArray:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.scoresArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScoreSelectionCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    ScoreSelectionCell *customCell = (ScoreSelectionCell *)cell;
    customCell.lblScore.text = [self.scoresArray objectAtIndex:indexPath.row];
    return customCell;
}

@end
