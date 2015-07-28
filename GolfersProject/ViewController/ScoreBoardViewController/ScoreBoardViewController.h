//
//  ScoreBoardViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreBoardViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
//@property (strong, nonatomic) IBOutlet UICollectionView *parentCollectionView;
//@property (strong, nonatomic) IBOutlet UIScrollView *parentScrollVIew;
@property (strong, nonatomic) IBOutlet UICollectionView *leftCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *rightCollectionView;

@end
