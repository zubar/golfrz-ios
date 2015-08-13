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
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+RoundedImage.h"
#import "EventAdminViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];

    NSLog(@"%@", self.currentEvent.name);
    
    
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    
    [imageButton addTarget:self action:@selector(backBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.navigationItem.title = @"EVENT DETAIL";
    
    //TODO:
    [self.imgEventLogo sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgEventLogo setRoundedImage:image];
        }
    }];
    
    [Utilities dateComponentsFromNSDate:self.currentEvent.dateStart components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString * minutes, NSString * hourAndMin) {
        [self.lblDay setText:[NSString stringWithFormat:@"%@ %@", monthName, day]];
        //TODO: Update the dateComponentsFromNSDate utility method to return time without am/ pm or in both formats
        [self.lblTime setText:hourAndMin];
    }];
    
    
    //[self.lblDay setText:[CalendarUtilities monthNameFromNum:eventDate.month]];
    //[self.lblTime setText:[NSString stringWithFormat:@"%ld:%ld", (long)eventDate.hour, (long)eventDate.minute]];
    [self.lblEventName setText:self.currentEvent.name];
    [self.lblEventDetails setText:self.currentEvent.breif];
    if( self.currentEvent.location && [self.currentEvent location].length >=1 ){
        [self.imgLocation setHidden:NO];
        [self.lblEventLocation setText:self.currentEvent.location];
    }else{
        [self.imgLocation setHidden:YES];
        [self.lblEventLocation setText:@""];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-10.0 forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString: @"segueToEventAdminController"]) {
        EventAdminViewController *dest = (EventAdminViewController *)[segue destinationViewController];
        dest.currentEvent=self.currentEvent;
    }
}


-(void)backBtnTapped{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController popViewControllerAnimated:YES];
}

- (IBAction)btnContactAdminTapped:(UIButton *)sender {
    
    
}

- (IBAction)btnInviteFriendsTapped:(UIButton *)sender {
}
@end
