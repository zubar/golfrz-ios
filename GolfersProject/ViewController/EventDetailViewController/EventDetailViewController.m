//
//  EventDetailViewController.m
//  GolfersProject
//
//  Created by Zubair on 5/27/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "EventDetailViewController.h"
#import "CalendarEvent.h"
#import "CalendarUtilities.h"
#import "ClubHouseSubController.h"
#import "AppDelegate.h"
#import "Utilities.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", self.currentEvent.name);
    
    
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    
    [imageButton addTarget:self action:@selector(backBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.navigationItem.title = @"EVENT DETAIL";
    
    
    //TODO: Event name in api.
    
   // NSDateComponents * eventDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.currentEvent.dateStart];
    
    
    [Utilities dateComponentsFromNSDate:self.currentEvent.dateStart components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time) {
        [self.lblDay setText:[NSString stringWithFormat:@"%@ %@", monthName, day]];
        [self.lblTime setText:time];
    }];
    
    
    //[self.lblDay setText:[CalendarUtilities monthNameFromNum:eventDate.month]];
    //[self.lblTime setText:[NSString stringWithFormat:@"%ld:%ld", (long)eventDate.hour, (long)eventDate.minute]];
    [self.lblEventName setText:self.currentEvent.name];
    [self.lblEventDetails setText:self.currentEvent.breif];
    [self.lblEventLocation setText:self.currentEvent.location];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-10.0 forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
//    UIPageControl * pageControl = (UIPageControl *)[self.navigationController.navigationBar viewWithTag:89];
//    if (pageControl && ![self isKindOfClass:[ClubHouseSubController class]]) {
//        [pageControl setHidden:YES];
//    }else{
//        [pageControl setHidden:NO];
//    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];

    
//    UIPageControl * pageControl = (UIPageControl *)[self.navigationController.navigationBar viewWithTag:89];
//    if (pageControl && ![self isKindOfClass:[ClubHouseSubController class]]) {
//        [pageControl setHidden:YES];
//    }else{
//        [pageControl setHidden:NO];
//    }
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

-(void)backBtnTapped{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController popViewControllerAnimated:YES];
}

- (IBAction)btnContactAdminTapped:(UIButton *)sender {
}

- (IBAction)btnInviteFriendsTapped:(UIButton *)sender {
}
@end
