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
@property (strong, nonatomic) IBOutlet UITextField *txtPlayers;

@property (weak, nonatomic) IBOutlet UIButton *btnBookTeetime;
- (IBAction)btnNoOfPlayersTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnNoOfPlayers;

- (void)setDidTapButtonBlock:(void (^)(id sender))didTapButtonBlock;

@end
