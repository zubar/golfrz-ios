//
//  ScoreSelectionView.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropdownDataSource <NSObject>
@required
-(NSArray *)dataArrayForCells;
@end

@protocol DropdownDelegate<NSObject>
@optional
-(void)selectedItemForCell:(id)item;
@end

@interface DropdownView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@property (assign, nonatomic) id<DropdownDataSource>dataSource;
@property (assign, nonatomic) id<DropdownDelegate>delegate;
@end
