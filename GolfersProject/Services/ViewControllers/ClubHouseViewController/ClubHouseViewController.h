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
#import "WEPopoverController.h"

@interface ClubHouseViewController : ClubHouseSubController<UICollectionViewDelegate, UICollectionViewDataSource, SharedManagerDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate
>
@property (strong, nonatomic) IBOutlet UICollectionView *weatherCollectionView;
@property (strong, nonatomic) IBOutlet UIImageView *imgCourseLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblCourseName;

- (IBAction)btnCheckedInTapped:(UIButton *)sender;
//- (IBAction)btnFoodAndBeverageTap:(id)sender;

- (IBAction)btnFoodBevTapped:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIButton *btnTeeTimesTapped;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnEventsTapped;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;


@property (weak, nonatomic) IBOutlet UIButton *btnCheckIn;
- (IBAction)btnTeeTimeTap:(id)sender;

/*
 *
 */
@property (weak, nonatomic) IBOutlet UIButton *btnTeetimes;
@property (weak, nonatomic) IBOutlet UILabel *lblTeeTimes;
@property (weak, nonatomic) IBOutlet UILabel *lblEvents;
@property (weak, nonatomic) IBOutlet UILabel *lblFoodAndBev;

@property (strong, nonatomic) IBOutlet UIView *teeTimesView;
@property (strong, nonatomic) IBOutlet UIView *eventsView;
@property (strong, nonatomic) IBOutlet UIView *foodBevView;

@property (weak, nonatomic) IBOutlet UIButton *btnEvents;
@property (weak, nonatomic) IBOutlet UIButton *btnFoodAndBeverage;

@end
