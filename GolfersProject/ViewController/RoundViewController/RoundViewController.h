//
//  RoundViewController.h
//  GolfersProject
//
//  Created by Zubair on 6/26/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerScoreView.h"
#import <CMPopTipView/CMPopTipView.h>
#import "ScoreSelectionView.h"
#import "PlayerScoreCell.h"
#import "RoundDataServices.h"


@interface RoundViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PlayerScoreViewDelegate, CMPopTipViewDelegate, ScoreSelectionDataSource, ScoreSelectionDelegate, PlayerScoreCellDelegate>

@property (strong, nonatomic) NSNumber * holeNumberPlayed;
@property (strong, nonatomic) IBOutlet UITableView *scoreTable;


@property (strong, nonatomic) IBOutlet UILabel *lblForward;
@property (strong, nonatomic) IBOutlet UILabel *lblMiddle;
@property (strong, nonatomic) IBOutlet UILabel *lblBack;
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) IBOutlet UIImageView *imageMap;

@property (strong, nonatomic) IBOutlet UILabel *lblHoleNo;

@property (strong, nonatomic) IBOutlet UILabel *lblPar;
@property (strong, nonatomic) IBOutlet UILabel *lblYards;
@property (strong, nonatomic) IBOutlet UIImageView *imgDarkerBg;
@property (strong, nonatomic) IBOutlet UIView *distanceView;

- (IBAction)btnPenaltyTapped:(UIButton *)sender;
- (IBAction)btnShotTapped:(UIButton *)sender;
- (IBAction)btnPuttTapped:(UIButton *)sender;
- (IBAction)btnFlyoverTapped:(UIButton *)sender;

- (IBAction)btnNextHoleTapped:(UIButton *)sender;
- (IBAction)btnPreviousHoleTapped:(UIButton *)sender;



@end
