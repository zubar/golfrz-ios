//
//  FoodBeverageBaseVC.m
//  GolfersProject
//
//  Created by Zubair on 6/24/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "FoodBeverageBaseVC.h"
#import "BBBadgeBarButtonItem.h"
#import "SharedManager.h"
#import "AppDelegate.h"
@interface FoodBeverageBaseVC ()

@end

@implementation FoodBeverageBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Left nav-bar.
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(backButtonTap) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // Right nav-bar.
    UIImage *image = [UIImage imageNamed:@"cart_icon"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,22, 22);
    [button addTarget:self action:@selector(cartButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    // Create and add our custom BBBadgeBarButtonItem
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:button];
    barButton.badgeBGColor = [UIColor greenColor];
    self.navigationItem.rightBarButtonItem = barButton;
    
    
    // NavTitle
    NSDictionary *navTitleAttributes =@{
                                        NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.0],
                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                        };
    
    self.navigationItem.title = @"FOOD & BEV BASE";
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
   
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    [delegate.appDelegateNavController.navigationBar setTitleVerticalPositionAdjustment:0.0 forBarMetrics:UIBarMetricsDefault];
    
    BBBadgeBarButtonItem * barItem= (BBBadgeBarButtonItem *) self.navigationItem.rightBarButtonItem;
    barItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[[SharedManager sharedInstance] cartBadgeCount]];

    [[SharedManager sharedInstance] updateCartItemsCountCompletion:^{
        barItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[[SharedManager sharedInstance] cartBadgeCount]];
    }];
}

-(void)backButtonTap{

}


-(void)cartButtonTap{

}
@end
