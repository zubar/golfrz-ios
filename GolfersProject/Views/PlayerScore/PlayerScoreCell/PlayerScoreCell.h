//
//  PlayerScoreCell.h
//  GolfersProject
//
//  Created by Zubair on 6/26/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerScoreView.h"

@protocol PlayerScoreCellDelegate <PlayerScoreViewDelegate>

@end


@interface PlayerScoreCell : UITableViewCell{
    id player;
}

@property (strong, nonatomic) NSNumber * score;

@property (strong, nonatomic) IBOutlet UIImageView *imgPlayerPic;
@property (strong, nonatomic) IBOutlet UILabel *lblPlayerName;
@property (strong, nonatomic) IBOutlet UILabel *lblInOut;
@property (strong, nonatomic) IBOutlet UILabel *lblScore;
@property (strong, nonatomic) IBOutlet UIButton *btnScore;

- (IBAction)btnScoreTapped:(UIButton *)sender;

@property (assign, nonatomic) id<PlayerScoreCellDelegate>delegate;

@end
