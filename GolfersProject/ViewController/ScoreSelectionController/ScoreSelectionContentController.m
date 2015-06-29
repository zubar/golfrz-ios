//
//  HorizontalSelectionController.m
//  GolfersProject
//
//  Created by Zubair on 6/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreSelectionContentController.h"
#import "ScoreSelectionCell.h"

@interface ScoreSelectionContentController ()

@end

@implementation ScoreSelectionContentController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.scores = [[NSMutableArray alloc] init];

    // Do any additional setup after loading the view.
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dataArrayForCells)]) {
        [self.scores removeAllObjects];
        [self.scores addObjectsFromArray:[self.dataSource dataArrayForCells]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [self.scores count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScoreSelectionCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }   
   
    ScoreSelectionCell *customCell = (ScoreSelectionCell *)cell;
    [customCell.contentView setBackgroundColor:[UIColor greenColor]];
    customCell.lblScore = [self.scores objectAtIndex:indexPath.row];

    return customCell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedItemForCell:)]) {
        [self.delegate selectedItemForCell:self.scores[indexPath.row]];
    }
}
@end
