//
//  RoundViewController.h
//  GolfersProject
//
//  Created by Zubair on 6/26/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerScoreView.h"

@interface RoundViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PlayerScoreViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *scoreTable;

@property (strong, nonatomic) IBOutlet UIView *distanceView;
@property (strong, nonatomic) IBOutlet UILabel *lblForward;
@property (strong, nonatomic) IBOutlet UILabel *lblMiddle;
@property (strong, nonatomic) IBOutlet UILabel *lblBack;
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) IBOutlet UIImageView *imageMap;

@property (strong, nonatomic) IBOutlet UILabel *lblHoleNo;

- (IBAction)btnPenaltyTapped:(UIButton *)sender;
- (IBAction)btnShotTapped:(UIButton *)sender;
- (IBAction)btnPuttTapped:(UIButton *)sender;
- (IBAction)btnFlyoverTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblPar;

@property (strong, nonatomic) IBOutlet UILabel *lblYards;
- (IBAction)btnNextHoleTapped:(UIButton *)sender;
- (IBAction)btnPreviousHoleTapped:(UIButton *)sender;

@end
