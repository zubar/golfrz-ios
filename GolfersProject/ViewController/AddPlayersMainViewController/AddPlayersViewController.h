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

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, DropDownContainsItems) {
    DropDownContainsItemsNone = 0,
    DropDownContainsItemsSubcourses,
    DropDownContainsItemsScoring,
    DropDownContainsItemsGametype,
    DropDownContainsItemsTeeboxes,
};


@interface AddPlayersViewController : BaseViewController<DropdownDataSource, DropdownDelegate, CMPopTipViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RoundData * roundInfo;

@property (weak, nonatomic) IBOutlet UIView *addPlayerContainerView;

@property (strong, nonatomic) IBOutlet UIView *selectCourses;

@property (weak, nonatomic) IBOutlet UIButton *btnSelectCourse;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectGametype;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectScoretype;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectTeebox;

@property (strong, nonatomic) IBOutlet UITableView *playersTable;


- (IBAction)btnAddPlayersTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnStartRound;

- (IBAction)btnStartRoundTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *playersTableContainerView;
- (IBAction)editPlayersTapped:(UIButton *)sender;

//TODO: rename PlayersTableView to PlayersContainerView

@end
