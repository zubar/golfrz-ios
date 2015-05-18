//
//  AppDelegate.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "BlueViewController.h"
#import "GreenViewController.h"
#import "GrayViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *mainController;
@property (strong, nonatomic) GreenViewController *greenViewController;
@property (strong, nonatomic) BlueViewController *blueViewController;
@property (strong, nonatomic) GrayViewController *grayViewController;

@end

