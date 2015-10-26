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
#import "WelcomeViewController.h"
#import "InitialViewController.h"
#import <AFNetworking/AFNetworking.h>

#define MAIN_CONTROL_IDENTIFIER @"mainPagingController"

#import <Google/Analytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PushManager.h"
#import "FaceBookAuthAgent.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Start Oberving network status
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;
    gai.logger.logLevel = kGAILogLevelNone;
    
    
    
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
        if ([[[url scheme] lowercaseString] isEqualToString:@"geneva-golf-and-country-club"]) {
            [[GameSettings sharedSettings] setInvitationToken:[self extractParamsFromUrl:[url query]][@"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAppLaunchUserTapInvitationLink object:nil];
            NSLog(@"Received invitation:%@", [[GameSettings sharedSettings] invitationToken]);
            return YES;
        }else
            return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kErrorUnAuthorizedAccess object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logOutFromAppUnAuthorizedToken) name:kErrorUnAuthorizedAccess object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - HelperMethod

- (void)logOutFromAppUnAuthorizedToken
{
    if (![self.appDelegateNavController.visibleViewController isKindOfClass:[InitialViewController class]] && ![self.appDelegateNavController.visibleViewController isKindOfClass:[WelcomeViewController class]])
    {
        [[[UIAlertView alloc] initWithTitle:@"Session Expired" message:@"Your current session has expired please login again to countinue" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
    [FaceBookAuthAgent disConnectFBAccount];
    [[GameSettings sharedSettings] resetGameSettings];
    [self popToSignInViewController];
    
}

-(void)popToSignInViewController
{
    bool hasWelcomeController = false;
    for (UIViewController *controller in self.appDelegateNavController.viewControllers)
        if ([controller isKindOfClass:[WelcomeViewController class]]) hasWelcomeController = true;
    
    for (UIViewController *controller in self.appDelegateNavController.viewControllers) {
        if (hasWelcomeController  && [controller isKindOfClass:[WelcomeViewController class]]){
            [self.appDelegateNavController popToViewController:controller animated:YES];
        }else
            if ([controller isKindOfClass:[InitialViewController class]]) {
                [self.appDelegateNavController popToViewController:controller animated:YES];
            }
    }
}


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
    
    return [[[options objectForKey:UIApplicationLaunchOptionsURLKey] scheme] isEqualToString:@"geneva-golf-and-country-club"];
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
