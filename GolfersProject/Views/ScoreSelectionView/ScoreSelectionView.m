//
//  ScoreSelectionView.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreSelectionView.h"
#import "ScoreSelectionCell.h"

@interface ScoreSelectionView ()
@property (nonatomic, strong) NSMutableArray *scoresArray;

@end

@implementation ScoreSelectionView

- (id)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ScoreSelectionView" owner:self options:nil] firstObject];
    }
    return self;
}

-(void)layoutSubviews{
    // Do any additional setup after loading the view.
    [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSelectionCellView" bundle:nil] forCellWithReuseIdentifier:@"ScoreSelectionCell"];

    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dataArrayForCells)]) {
        if (self.scoresArray == nil) {
            self.scoresArray = [[NSMutableArray alloc] init];
        }
        [self.scoresArray removeAllObjects];
        [self.scoresArray addObjectsFromArray:[self.dataSource dataArrayForCells]];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

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

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedItemForCell:)]) {
        [self.delegate selectedItemForCell:self.scoresArray[indexPath.row]];
    }
}


@end
