//
//  TeeTimeBookingCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/8/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeeTimeBookingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
- (IBAction)btnBookTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtPlayers;

@end
