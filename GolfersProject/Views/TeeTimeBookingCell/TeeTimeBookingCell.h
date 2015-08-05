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

@property (weak, nonatomic) IBOutlet UIButton *btnBookTeetime;
@property (strong, nonatomic) IBOutlet UIButton *btnNoOfPlayers;

- (IBAction)btnNoOfPlayersTapped:(UIButton *)sender;


- (void)setDidTapButtonBlock:(void (^)(id sender))didTapButtonBlock;
- (void)setDidTapPlayerCountBtnBlock:(void(^)(id sender))didTapPlayerCountBlock;

@end
