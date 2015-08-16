//
//  TeeTimesViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/8/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ScoreSelectionView.h"
#import <CMPopTipView/CMPopTipView.h>

@interface TeeTimesViewController : BaseViewController<ScoreSelectionDataSource, ScoreSelectionDelegate, CMPopTipViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgCourseLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblCourseName;

@property (strong, nonatomic) IBOutlet UILabel *lblSelectedDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgWeatherImage;
@property (strong, nonatomic) IBOutlet UILabel *lblTemperature;
@property (strong, nonatomic) IBOutlet UILabel *lblSubCourseName;
@property (strong, nonatomic) IBOutlet UIButton *btnShowCoursesTapped;
@property (strong, nonatomic) IBOutlet UITableView *teeTimesTable;

- (IBAction)btnShowCalendarTapped:(UIButton *)sender;
- (IBAction)btnSubcourseTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;

@end
