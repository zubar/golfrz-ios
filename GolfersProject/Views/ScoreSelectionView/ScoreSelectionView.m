//
//  ScoreSelectionView.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreSelectionView.h"
#import "ScoreSelectionCell.h"

@implementation ScoreSelectionView

- (id)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ScoreSelectionView class]) owner:self options:nil] firstObject];
        [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSelectionCellView" bundle:nil] forCellWithReuseIdentifier:@"ScoreSelectionCell"];
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScoreSelectionCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    ScoreSelectionCell *customCell = (ScoreSelectionCell *)cell;
    return customCell;
}

@end
