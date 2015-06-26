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
    self.scores = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScoreSelectionCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }   
   
    ScoreSelectionCell *customCell = (ScoreSelectionCell *)cell;
    customCell.lblScore = [self.scores objectAtIndex:indexPath.row];
    return customCell;
    
}




@end
