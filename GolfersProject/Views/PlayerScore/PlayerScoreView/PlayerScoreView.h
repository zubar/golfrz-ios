//
//  EventHeader.h
//  GolfersProject
//
//  Created by Zubair on 6/1/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerScoreViewDelegate <NSObject>
-(void)dropDownTapped;
-(void)editScoreTappedForPlayer:(id)sender Player:(id)player;
@end

@interface PlayerScoreView : UIView{
    id player;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgBackGround;

@property (strong, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblInOut;
@property (strong, nonatomic) IBOutlet UILabel *lblScoreForHole;

@property (strong, nonatomic) IBOutlet UIButton *btnShowTable;
@property (weak, nonatomic) IBOutlet UIButton *btnEditScore;


@property (assign, nonatomic) id<PlayerScoreViewDelegate>delegate;

-(void)configureViewForPlayer:(id)mPlayer hideDropdownBtn:(BOOL)yesNo;

@end
