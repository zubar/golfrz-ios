//
//  AppDelegate.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "AppDelegate.h"
#import "RewardViewController.h"
#import "ClubHouseViewController.h"
#import "PlayerProfileViewController.h"
#import "SplashScreenViewController.h"
#import "GameSettings.h"
#import "Constants.h"
#import "InvitationManager.h"

#define MAIN_CONTROL_IDENTIFIER @"mainPagingController"


#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PushManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-10.0 forBarMetrics:UIBarMetricsDefault];
    _shouldRestricOrient = NO;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    SplashScreenViewController * splashController = (SplashScreenViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"SplashScreenViewController"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.appDelegateNavController = [[UINavigationController alloc]initWithRootViewController:splashController];
    self.window.rootViewController = self.appDelegateNavController;
    [self.window makeKeyAndVisible];
    
    [[PushManager sharedInstance] registerForPushMessages];
    
    return [self isValidCustomUrlSchemeForApplication:application
                                        launchOptions:launchOptions] ||
            [self isValidFacebookUrlForApplication:application
                                     launchOptions:launchOptions];
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // check if the facebookAppID key is present then send objects to FBSDK.
    if ([[url absoluteString] containsString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"]]) {
       
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }else
        if ([[[url scheme] lowercaseString] isEqualToString:@"invitationreceived"]) {
            [[InvitationManager sharedInstance] setInvitationToken:[self extractParamsFromUrl:[url query]][@"invitation"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAppLaunchInvitationReceived object:nil];
            NSLog(@"Received invitation:%@", [[InvitationManager sharedInstance] invitationToken]);
            return YES;
        }else
            return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}
//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    if (!_shouldRestricOrient) {
//        return UIInterfaceOrientationMaskPortraitUpsideDown;
//    }
//    return UIInterfaceOrientationMaskAll;
//}
- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - HelperMethod
/*
 Method checks if the scheme is valid url for app, i.e, it checks if the url is either facebook url scheme 
 or its custom url scheme defined in info.plist of app.
 */

// Current defined url schemes are "invitationReceived".

-(BOOL)isValidCustomUrlSchemeForApplication:(UIApplication *)application launchOptions:(NSDictionary *)options{
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   didFinishLaunchingWithOptions:options];
}

-(BOOL)isValidFacebookUrlForApplication:(UIApplication *)application launchOptions:(NSDictionary *)options{
    
    return [[[options objectForKey:UIApplicationLaunchOptionsURLKey] scheme] isEqualToString:@"invitationReceived"];
}

#pragma mark - UtilityMethod
-(NSDictionary *)extractParamsFromUrl:(NSString *)url{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    
    for (NSString *param in [url componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
    }
    return params;
}
@end
