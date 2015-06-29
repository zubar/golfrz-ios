//
//  HorizontalSelectionController.h
//  GolfersProject
//
//  Created by Zubair on 6/25/15.
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

@interface ScoreSelectionContentController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray* scores;
@property (strong, nonatomic) IBOutlet UICollectionView *scoreCollectionView;

@property (assign, nonatomic) id<ScoreSelectionDataSource>dataSource;
@property (assign, nonatomic) id<ScoreSelectionDelegate>delegate;
@end
