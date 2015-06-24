//
//  GreenViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClubHouseSubController.h"
#import "SharedManager.h"

@interface ClubHouseViewController : ClubHouseSubController<UICollectionViewDelegate, UICollectionViewDataSource, SharedManagerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *weatherCollectionView;
@property (strong, nonatomic) IBOutlet UIImageView *imgCourseLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblCourseName;

- (IBAction)btnCheckedInTapped:(UIButton *)sender;
//- (IBAction)btnFoodAndBeverageTap:(id)sender;

- (IBAction)btnFoodBevTapped:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIButton *btnTeeTimesTapped;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnEventsTapped;



@property (weak, nonatomic) IBOutlet UIButton *btnCheckIn;
- (IBAction)btnTeeTimeTap:(id)sender;

@end
