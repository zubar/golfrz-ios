//
//  BlueViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClubHouseSubController.h"

@interface PlayerProfileViewController : ClubHouseSubController

- (IBAction)btnSettingsTapped:(UIButton *)sender;
- (IBAction)btnStartRoundTapped:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblHandicap;
@property (strong, nonatomic) IBOutlet UILabel *lblPoints;
@property (strong, nonatomic) IBOutlet UIView *myScorecardsTapped;
@property (strong, nonatomic) IBOutlet UILabel *lblCourseName;

@property (weak, nonatomic) IBOutlet UIButton *btnStartRound;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;


@end
