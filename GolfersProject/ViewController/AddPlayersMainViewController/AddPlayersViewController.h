//
//  AddPlayersViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/1/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundData.h"
#import <CMPopTipView/CMPopTipView.h>
#import "DropdownView.h"




@interface AddPlayersViewController : UIViewController<DropdownDataSource, DropdownDelegate, CMPopTipViewDelegate>

@property (nonatomic, strong) RoundData * roundInfo;

- (IBAction)btnAddPlayersTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *selectCourses;
@property (strong, nonatomic) IBOutlet UIView *selectGameType;
@property (strong, nonatomic) IBOutlet UIView *selectScoring;
@property (strong, nonatomic) IBOutlet UIView *selectTeeBox;

@property (strong, nonatomic) IBOutlet UILabel *lblCourse;
@property (strong, nonatomic) IBOutlet UIImageView *courseDropDown;
@property (strong, nonatomic) IBOutlet UILabel *lblGameType;
@property (strong, nonatomic) IBOutlet UIImageView *gameTypeDropDown;
@property (strong, nonatomic) IBOutlet UILabel *lblScoring;
@property (strong, nonatomic) IBOutlet UIImageView *scoringDropDown;
@property (strong, nonatomic) IBOutlet UILabel *lblTeeBox;
@property (strong, nonatomic) IBOutlet UIImageView *teeBoxDropDown;
- (IBAction)btnSelectCourseTapped:(UIButton *)sender;
- (IBAction)btnSelectGameTypeTapped:(UIButton *)sender;
- (IBAction)btnSelectScoringTapped:(UIButton *)sender;
- (IBAction)btnSelectTeeBoxTapped:(UIButton *)sender;



@end
