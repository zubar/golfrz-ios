//
//  HorizontalSelectionController.h
//  GolfersProject
//
//  Created by Zubair on 6/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreSelectionContentController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray* scores;
@property (strong, nonatomic) IBOutlet UICollectionView *scoreCollectionView;

@end
