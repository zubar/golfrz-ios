//
//  ClubHouseViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/21/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClubHouseViewController.h"
#import "PlayerProfileViewController.h"
#import "RewardViewController.h"

@interface ClubHouseContainerVC : UIViewController
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, retain) ClubHouseViewController *  clubHouseViewController;
@property (nonatomic, retain) PlayerProfileViewController *  playerProfileViewController;
@property (nonatomic, retain) RewardViewController * rewardViewController;
@end
