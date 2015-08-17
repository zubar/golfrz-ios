//
//  EventAdminViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/29/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "EventAdminViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "UIImageView+RoundedImage.h"
#import "CourseServices.h"
#import "Coordinate.h"
#import "Utilities.h"
#import "Constants.h"
#import "Course.h"

@interface EventAdminViewController ()

- (void)viewMapSelected;

@end

@implementation EventAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];
;

    
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    
    [imageButton addTarget:self action:@selector(eventAdminBackBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewMapSelected)];
    [self.lblViewMap addGestureRecognizer:tapGesture];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.navigationItem.title = @"CONTACT ADMIN";
    
    [self loadDataForCurrentEvent];
}


-(void)loadDataForCurrentEvent{
   
    [self.imgEventLogo sd_setImageWithURL:[NSURL URLWithString:self.currentEvent.imagePath] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgEventLogo setRoundedImage:image];
        }
    }];
    Course * mCourse = [CourseServices currentCourse];
    
    [self.lblEventName setText:self.currentEvent.name];
    [self.lblCourseName setText:[mCourse courseName]];
    [self.lblStreetAddress setText:[mCourse courseAddress]];
    [self.lblState setText:[mCourse courseState]];
    [self.lblCity setText:[mCourse courseCity]];
    [self.lblPostalCode setText:[[mCourse postalCode] stringValue]];
    [self.lblEventLocation setText:[self.currentEvent location]];
    
    
    [Utilities dateComponentsFromNSDate:[self.currentEvent dateStart] components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString * timeAndMinutes) {
        [self.lblDay setText:[NSString stringWithFormat:@"%@ %@", day, monthName]];
        [self.lblTime setText:timeAndMinutes];
    }];
    
    //TODO:
    /*
    @property (strong, nonatomic) IBOutlet UILabel *lblViewMap;
    @property (strong, nonatomic) IBOutlet UILabel *lblEventLocation;
    */
    //TODO:
    [self.imgAdminPic sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgAdminPic setRoundedImage:image];
        }
    }];
    
    EventAdmin * admin = [self.currentEvent eventAdmin];
    [self.lblAdminName setText:[NSString stringWithFormat:@"%@ %@", [admin firstName], [admin lastName]]];
    [self.lblAdminPost setText:[admin designation]];
    [self.lblEmail setText:[admin email]];
    [self.lblContactNo setText:[admin phoneNo]];
    
}

- (void)viewMapSelected {
    [Utilities viewMap];
}

/*
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
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)eventAdminBackBtnTapped{
    [self.navigationController popViewControllerAnimated:YES];
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
