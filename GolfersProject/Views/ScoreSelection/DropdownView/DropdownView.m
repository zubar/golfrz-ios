//
//  ScoreSelectionView.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "DropdownView.h"
#import "DropdownCell.h"

@interface DropdownView ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DropdownView

- (id)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DropdownView" owner:self options:nil] firstObject];
    }
    return self;
}

-(void)layoutSubviews{
    // Do any additional setup after loading the view.
    [self.collectionView registerNib:[UINib nibWithNibName:@"DropdownCell" bundle:nil] forCellWithReuseIdentifier:@"DropdownCell"];

    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dataArrayForCells)]) {
        if (self.dataArray == nil) {
            self.dataArray = [[NSMutableArray alloc] init];
        }
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[self.dataSource dataArrayForCells]];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [self.dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DropdownCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    DropdownCell *customCell = (DropdownCell *)cell;
    customCell.lblText.text = [self.dataArray objectAtIndex:indexPath.row];
    return customCell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedItemForCell:)]) {
        [self.delegate selectedItemForCell:self.dataArray[indexPath.row]];
    }
}


@end
