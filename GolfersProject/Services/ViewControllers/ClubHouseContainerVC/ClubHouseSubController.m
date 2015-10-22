//
//  ClubHouseSubController.m
//  GolfersProject
//
//  Created by Zubair on 5/21/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ClubHouseSubController.h"

@interface ClubHouseSubController ()

@end

@implementation ClubHouseSubController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setHidesBackButton:YES animated:NO];

    
    UISwipeGestureRecognizer *  rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(popToPreviousController)];
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *  leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pushNextController)];
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:leftRecognizer];
    
}


- (void)pushNextController{
//subclass will override
}

-(void)popToPreviousController{
    //subclass will override
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
