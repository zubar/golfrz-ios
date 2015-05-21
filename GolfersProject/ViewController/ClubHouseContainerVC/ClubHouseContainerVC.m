//
//  ClubHouseViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/21/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ClubHouseContainerVC.h"
#import "MainViewController.h"
#import "ClubHouseViewController.h"
#import "PlayerProfileViewController.h"
#import "RewardViewController.h"


@interface ClubHouseContainerVC ()<UINavigationControllerDelegate>
@property (nonatomic, strong) UINavigationController * navController;
@end


@implementation ClubHouseContainerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     self.clubHouseViewController = (ClubHouseViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"ClubHouseViewController"];
    self.playerProfileViewController = (PlayerProfileViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"PlayerProfileViewController"];
    self.rewardViewController = (RewardViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"RewardViewController"];
    
    NSMutableArray *controllersArray = [NSMutableArray array];
    [controllersArray addObject:self.clubHouseViewController];
    [controllersArray addObject:self.playerProfileViewController];
    //[controllersArray addObject:self.rewardViewController];
    
    
    self.navController = [[UINavigationController alloc]init];
    [self.navController setViewControllers:controllersArray];
    
    
    CGSize navBarSize = self.navController.navigationBar.bounds.size;
    self.navController.navigationBar.barTintColor = [UIColor redColor];

    CGPoint origin = CGPointMake( navBarSize.width/2, navBarSize.height/2 );
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(origin.x, origin.y,
                                                                       0, 0)];
    
    //Or whatever number of viewcontrollers you have
    [self.pageControl setNumberOfPages:3];
    [self.navController setNavigationBarHidden:NO];
    [self.navController.navigationBar addSubview:self.pageControl];
    
    self.navController.delegate = self;
    
    self.clubHouseViewController.containerVC = self;
    self.playerProfileViewController.containerVC = self;
    self.rewardViewController.containerVC = self;
    
    
    [self.view addSubview:self.navController.view];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSUInteger  index = [navigationController.viewControllers indexOfObject:viewController];
    self.pageControl.currentPage = index;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
