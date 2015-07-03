//
//  AddPlayersInvitedController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/2/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPlayersInvitedController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *playersTable;
@property (strong, nonatomic) IBOutlet UIButton *btnStartRound;
- (IBAction)btnStartRoundTapped:(UIButton *)sender;

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


@end
