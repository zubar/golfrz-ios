//
//  SignInViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/15/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "SignInViewController.h"
#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"
#import "ClubHouseViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //[super viewWillAppear:YES];
    [self addGestureToForgotPassword];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addGestureToForgotPassword{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPasswordTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblForgotPassword setUserInteractionEnabled:YES];
    [self.lblForgotPassword addGestureRecognizer:gesture];
}

- (void)forgotPasswordTapped{
    ForgotPasswordViewController *forgotPasswordViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    
    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSignInTapped:(id)sender {
    
    ClubHouseViewController *clubHouseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubHouseViewController"];
    
    [self.navigationController pushViewController:clubHouseVC animated:YES];

//    
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    
//    
//        appDelegate.mainController = (MainViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"mainPagingController"];
//        appDelegate.greenViewController = (GreenViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"GreenViewController"];
//        appDelegate.blueViewController = (BlueViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"BlueViewController"];
//        appDelegate.grayViewController = (GrayViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"GrayViewController"];
//    
//    
//    
//        NSMutableArray *controllersArray = [NSMutableArray array];
//        [controllersArray addObject:appDelegate.greenViewController];
//        [controllersArray addObject:appDelegate.blueViewController];
//        [controllersArray addObject:appDelegate.grayViewController];
//    
//        [appDelegate.mainController setViewControllers:controllersArray];
//    
//    
//        appDelegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:appDelegate.mainController];
//    
//    
//        [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
//        [[UINavigationBar appearance] setBackgroundColor:[UIColor redColor]];
//        [[UINavigationBar appearance] setTranslucent:FALSE];
//        [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    // Override point for customization after application launch.
    
    
    
    /*
    
    
        self.mainController = (MainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"mainPagingController"];
        self.greenViewController = (GreenViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"GreenViewController"];
        self.blueViewController = (BlueViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"BlueViewController"];
        self.grayViewController = (GrayViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"GrayViewController"];
    
    
    
        NSMutableArray *controllersArray = [NSMutableArray array];
        [controllersArray addObject:self.greenViewController];
        [controllersArray addObject:self.blueViewController];
        [controllersArray addObject:self.grayViewController];
    
        [self.mainController setViewControllers:controllersArray];
    
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.mainController];
    
        [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor redColor]];
        [[UINavigationBar appearance] setTranslucent:FALSE];
        [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    
    */
}
@end
