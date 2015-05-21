//
//  AppDelegate.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "RewardViewController.h"
#import "CloubHouseViewController.h"
#import "PlayerProfileViewController.h"
#define MAIN_CONTROL_IDENTIFIER @"mainPagingController"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
//    
//    self.mainController = (MainViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:MAIN_CONTROL_IDENTIFIER];
//    self.greenViewController = (GreenViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"GreenViewController"];
//    self.blueViewController = (BlueViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"BlueViewController"];
//    self.grayViewController = (GrayViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"GrayViewController"];
//    
//    
//    
//    NSMutableArray *controllersArray = [NSMutableArray array];
//    [controllersArray addObject:self.greenViewController];
//    [controllersArray addObject:self.blueViewController];
//    [controllersArray addObject:self.grayViewController];
//    
//    [self.mainController setViewControllers:controllersArray];
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.mainController];
//    
//    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor redColor]];
//    [[UINavigationBar appearance] setTranslucent:FALSE];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
