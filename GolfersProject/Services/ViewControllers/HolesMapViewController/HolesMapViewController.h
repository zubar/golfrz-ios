//
//  HolesMapViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HolesMapViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>

- (IBAction)btnNextHolesTapped:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnNextHoles;
@property (strong, nonatomic) IBOutlet UICollectionView *holeCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;

@end
