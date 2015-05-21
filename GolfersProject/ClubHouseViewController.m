//
//  ClubHouseViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/21/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ClubHouseViewController.h"
#import "MainViewController.h"
#import "GreenViewController.h"
#import "BlueViewController.h"
#import "GrayViewController.h"
#import "WeatherViewCell.h"


@interface ClubHouseViewController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@end


@implementation ClubHouseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GreenViewController *  greenViewController = (GreenViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"GreenViewController"];
    
    BlueViewController *  blueViewController = (BlueViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"BlueViewController"];


    GrayViewController * grayViewController = (GrayViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"GrayViewController"];
    
    
            NSMutableArray *controllersArray = [NSMutableArray array];
            [controllersArray addObject:greenViewController];
            [controllersArray addObject:blueViewController];
            [controllersArray addObject:grayViewController];
    
    
    UINavigationController * navController = self.navigationController;
    
    [navController setViewControllers:controllersArray];
    navController.delegate = self;
    
    navController.navigationBar.barTintColor = [UIColor greenColor];
    
    CGSize navBarSize = navController.navigationBar.bounds.size;
    CGPoint origin = CGPointMake( navBarSize.width/2, navBarSize.height/2 );
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(origin.x, origin.y,
                                                                       0, 0)];
    
    //Or whatever number of viewcontrollers you have
    [self.pageControl setNumberOfPages:3];
    [navController setNavigationBarHidden:NO];
    
    [navController.navigationBar addSubview:self.pageControl];
    
    navController.delegate = self;
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSUInteger  index = [navigationController.viewControllers indexOfObject:viewController];
    self.pageControl.currentPage = index;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeatherCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    WeatherViewCell *customCell = (WeatherViewCell *)cell;
    
    return customCell;
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
