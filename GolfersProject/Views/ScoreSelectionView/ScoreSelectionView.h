//
//  ScoreSelectionView.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScoreSelectionDataSource <NSObject>
@required
-(NSArray *)dataArrayForCells;
@end

@protocol ScoreSelectionDelegate<NSObject>
@optional
-(void)selectedItemForCell:(id)item;
@end

@interface ScoreSelectionView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@property (assign, nonatomic) id<ScoreSelectionDataSource>dataSource;
@property (assign, nonatomic) id<ScoreSelectionDelegate>delegate;
@end
