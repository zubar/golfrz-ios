//
//  RoundPlayerCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/2/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundPlayerCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgPlayerPic;

@property (strong, nonatomic) IBOutlet UILabel *lblHandicap;
@property (strong, nonatomic) IBOutlet UILabel *lblPlayerName;

@end
