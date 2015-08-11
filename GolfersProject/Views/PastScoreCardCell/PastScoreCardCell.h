//
//  PastScoreCardCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/11/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastScoreCardCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblDayDate;
@property (strong, nonatomic) IBOutlet UILabel *lblYear;
@property (strong, nonatomic) IBOutlet UILabel *lblScoreCardIdentifier;
@property (strong, nonatomic) IBOutlet UILabel *lblGameType;
@property (strong, nonatomic) IBOutlet UILabel *lblScore;

@end
