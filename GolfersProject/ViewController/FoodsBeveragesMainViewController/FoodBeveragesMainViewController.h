//
//  FoodBeveragesMainViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/8/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodBeveragesMainViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray *foodArray;
@property (strong, nonatomic) NSMutableArray *bevArray;
@property (strong, nonatomic) IBOutlet UICollectionView *foodBevCollectionView;

- (IBAction)btnFoodTapped:(UIButton *)sender;

- (IBAction)btnBevTapped:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *buttonFood;
@property (strong, nonatomic) IBOutlet UIButton *buttonBeverage;


@end
