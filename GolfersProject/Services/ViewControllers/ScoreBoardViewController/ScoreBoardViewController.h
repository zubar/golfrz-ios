//
//  ScoreBoardViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ScoreBoardViewController : BaseViewController<UICollectionViewDataSource,
                                                        UICollectionViewDelegate,
                                                        UIScrollViewDelegate>

@property (strong, nonatomic) NSNumber * subCourseId;
@property (strong, nonatomic) NSNumber * roundId;
@property (strong, nonatomic) IBOutlet UICollectionView *rightCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblheadingScorecard;
@property (strong, nonatomic) IBOutlet UILabel *lblDateOfRound;
@property (strong, nonatomic) IBOutlet UILabel *lblNoOfHoles;
@property (strong, nonatomic) IBOutlet UILabel *lblGameType;
@property (strong, nonatomic) NSString *previousDate;
@property (strong, nonatomic) NSString *previousGameType;

@end
