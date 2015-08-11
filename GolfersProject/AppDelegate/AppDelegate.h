//
//  AppDelegate.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerProfileViewController.h"
#import "ClubHouseViewController.h"
#import "RewardViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic,assign)BOOL shouldRestricOrient;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController * appDelegateNavController;

@property (strong, nonatomic) ClubHouseViewController *greenViewController;
@property (strong, nonatomic) PlayerProfileViewController *blueViewController;
@property (strong, nonatomic) RewardViewController *grayViewController;

@end

