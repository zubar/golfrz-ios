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

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", self.currentEvent.name);
    
    //TODO: Event name in api.
    
    NSDateComponents * eventDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.currentEvent.dateStart];
    
    
    [self.lblDay setText:[CalendarUtilities monthNameFromNum:eventDate.month]];
    [self.lblTime setText:[NSString stringWithFormat:@"%ld:%ld", (long)eventDate.hour, (long)eventDate.minute]];
    [self.lblEventName setText:self.currentEvent.name];
    [self.lblEventDetails setText:self.currentEvent.breif];
    [self.lblEventLocation setText:self.currentEvent.location];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    UIPageControl * pageControl = (UIPageControl *)[self.navigationController.navigationBar viewWithTag:89];
    if (pageControl && ![self isKindOfClass:[ClubHouseSubController class]]) {
        [pageControl setHidden:YES];
    }else{
        [pageControl setHidden:NO];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    UIPageControl * pageControl = (UIPageControl *)[self.navigationController.navigationBar viewWithTag:89];
    if (pageControl && ![self isKindOfClass:[ClubHouseSubController class]]) {
        [pageControl setHidden:YES];
    }else{
        [pageControl setHidden:NO];
    }
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

- (IBAction)btnContactAdminTapped:(UIButton *)sender {
}

- (IBAction)btnInviteFriendsTapped:(UIButton *)sender {
}
@end
