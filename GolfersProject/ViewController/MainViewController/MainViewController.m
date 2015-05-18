//
//  MainViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MainViewController.h"
#import "XHPaggingNavbar.h"
#import "XHTwitterPaggingViewer.h"
#import "AppDelegate.h"
#import "GreenViewController.h"
#import "BlueViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)callBackChangedPage {
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.mainController.getCurrentPageIndex == 0) {
        appDelegate.mainController.delegate = appDelegate.greenViewController;
    }else
        if (appDelegate.mainController.getCurrentPageIndex == 1){
        appDelegate.mainController.delegate = appDelegate.blueViewController;
    }
    
    
    
    if (self.delegate) {
        NSDictionary * btnsDict =  [self.delegate updateNavBarRightButtons];
        
        
        
        if([self.paggingNavbar viewWithTag:10]){ // left butn already exists so remove it first
            UIButton * l_btn= (UIButton *)[self.paggingNavbar viewWithTag:10];
            [l_btn removeFromSuperview];
            UIButton * btn = [btnsDict objectForKey:@"left_btn"];
            [btn setTag:10];
            [self.paggingNavbar addSubview:btn];
        }else{
            UIButton * btn = [btnsDict objectForKey:@"left_btn"];
            [btn setTag:10];
            [self.paggingNavbar addSubview:btn];
        }
        
    }
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
