//
//  TeeTimeBookingCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/8/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teetime.h"

@interface TeeTimeBookingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (assign, nonatomic) NSInteger playerCount;

@property (weak, nonatomic) IBOutlet UIButton *btnBookTeetime;
@property (strong, nonatomic) IBOutlet UIButton *btnNoOfPlayers;

-(void)updateViewBtnForTeetime:(Teetime *)teetime;

- (void)setDidTapButtonBlock:(void (^)(id sender, NSInteger playercount))didTapButtonBlock;
- (void)setDidTapPlayerCountBtnBlock:(void(^)(id sender ))didTapPlayerCountBlock;

@end
