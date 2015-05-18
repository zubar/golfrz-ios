//
//  SignUpViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "SignUpViewController.h"
#import "InitialViewController.h"


@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    //[super viewWillAppear:animated];
    // Do any additional setup after loading the view.
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

#pragma ButtonActions

- (IBAction)btnRegisterTapped:(UIButton *)sender {
   
    
    
}

- (IBAction)btnBackTapped:(UIButton *)sender {
    //[self performSegueWithIdentifier:@"backToMainSegue" sender:nil];
    InitialViewController *initialViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [self.navigationController pushViewController:initialViewController animated:NO];
}




@end
