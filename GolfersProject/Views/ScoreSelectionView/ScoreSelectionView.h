//
//  ScoreSelectionView.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreSelectionView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
