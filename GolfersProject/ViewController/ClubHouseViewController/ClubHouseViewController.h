//
//  GreenViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClubHouseSubController.h"

@interface ClubHouseViewController : ClubHouseSubController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *weatherCollectionView;

@end
