//
//  GreenViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ClubHouseContainerVC.h"
#import "WeatherViewCell.h"
#import "WeatherServices.h"
#import "MBProgressHUD.h"
#import "UserServices.h"
#import "InvitationServices.h"
#import "AppDelegate.h"
#import "AddPlayersViewController.h"
#import "InitialViewController.h"

#import "CourseServices.h"
#import "EventCalendarViewController.h"
#import "EventDetailViewController.h"
#import "AppDelegate.h"
#import "ContactUsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SharedManager.h"
#import "UIImageView+RoundedImage.h"
#import "FoodBeveragesMainViewController.h"
#import "SideNotificationView.h"
#import "FoodBeverageServices.h"
#import "ContactServices.h"
#import "APContact+convenience.h"
#import "Constants.h"
#import "Utilities.h"
#import "CourseUpdatesViewController.h"
#import "FeaturedControl.h"
#import "NSDate+Helper.h"

#import "RoundDataServices.h"

#import "RoundViewController.h"
#import "ScoreSelectionView.h"
#import "GameSettings.h"
#import "RoundMoviePlayerController.h"
#import "TeeTimesViewController.h"
#import "HMMessagesDisplayViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WelcomeViewController ()
{
    NSDate * lastWeatherUpdateTime;
}
@property (nonatomic, retain) NSArray * weatherList;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];

    /*
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 22, 22)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"contactus_button"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(btnContactUsTap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton * imageRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 22, 22)];
    [imageRightButton setBackgroundImage:[UIImage imageNamed:@"activity_icon"] forState:UIControlStateNormal];
    [imageRightButton addTarget:self action:@selector(btnCourseUpdatesTap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageRightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
   
    NSDictionary *titleAttributes =@{
                                    NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.0],
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                    };
    
    self.navigationController.navigationBar.titleTextAttributes = titleAttributes;
    [[self navigationItem] setTitle:@"CLUBHOUSE"];
    */
    
    
    // Receive this notification to check if there are any pending invitations to show.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayAlertForPendingInvitations) name:kAppLaunchUserTapInvitationLink object:nil];
    [self  loadCourseDetailsCompletionBlock:^(Course *currentCourse) {
        // Loading course details to use by courseServices, Must call this. 
    }];
    [self loadDataForCurrentCourse];
    [self.lblCourseCityState setText:[NSString stringWithFormat:@"%@, %@", manager.courseCity, manager.courseState]];

}

-(void)loadDataForCurrentCourse{
    SharedManager * manager = [SharedManager sharedInstance];
    [self.lblCourseName setText:[manager courseName]];
   
    [self.imgCourseLogo sd_setImageWithURL:[NSURL URLWithString:[manager logoImagePath]] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgCourseLogo setRoundedImage:image];
        }
    }];
}

-(void)loadCourseDetailsCompletionBlock:(void (^)(Course *currentCourse))completionBlock
{
    
    [CourseServices courseDetailInfo:^(bool status, Course *currentCourse) {
        if (status) {
            if (status) {
                completionBlock(currentCourse);
            }
        }
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setHidden:YES];

//    UIPageControl * pageControl = (UIPageControl *)[self.navigationController.navigationBar viewWithTag:89];
//    if (pageControl && ![self isKindOfClass:[ClubHouseSubController class]]) {
//        [pageControl setHidden:YES];
//    }else{
//        [pageControl setHidden:NO];
//    }
   // [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-10.0 forBarMetrics:UIBarMetricsDefault];
    
    //Update weatherData
    [self updateWeatherData];
}

- (void)updateWeatherData {
    // Do any additional setup after loading the view.
    if ([self.weatherList count] > 0) {
        // Don't update weather if time interval is less than 60 minute.
        if([self minutesBetween:lastWeatherUpdateTime endDate:[NSDate date]] < 30) return;
    }else{
        lastWeatherUpdateTime = [NSDate date];
        [self.lblWeatherDate setText:@"Updating Weather Forecast..."];
            }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WeatherServices weatherInfo:^(bool status, NSArray *mWeatherData) {
        if (status) {
            if([mWeatherData count] > 0){
            self.weatherList = mWeatherData;
                [self.weatherCollectionView setHidden:NO];
                [self.weatherCollectionView reloadData];
            }else{
                [self.weatherCollectionView setHidden:YES];
                [self.lblWeatherDate setText:@"Weather Forecast Not Available."];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(bool status, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[[UIAlertView alloc]initWithTitle:@"Try Again" message:@"Failed to get weather" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    
//    UIPageControl * pageControl = (UIPageControl *)[self.navigationController.navigationBar viewWithTag:89];
//    if (pageControl && ![self isKindOfClass:[ClubHouseSubController class]]) {
//        [pageControl setHidden:YES];
//    }else{
//        [pageControl setHidden:NO];
//    }
    
    [SharedManager sharedInstance].delegate = nil;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.weatherList count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeatherCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    WeatherData * tempWeather = [self.weatherList objectAtIndex:indexPath.row];
    
    WeatherViewCell * customCell = (WeatherViewCell *)cell;
    [customCell.lblTime setText:[self hoursFromDate:tempWeather.timeStamp]];
    [customCell.lblTemperature setText:[NSString stringWithFormat:@"%.1f F", [[tempWeather temperature] floatValue]]];
    [customCell.imgWeatherIcon sd_setImageWithURL:[NSURL URLWithString:tempWeather.condition.icon] completed:^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL *imageURL) {
        [customCell.imgWeatherIcon setImage:image];
    } ];
    
    return customCell;
}


-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherData * tempWeather = [self.weatherList objectAtIndex:indexPath.row];
    [Utilities dateComponents:[tempWeather timeStamp] components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute, NSString *year) {
        [self.lblWeatherDate setText:[NSString stringWithFormat:@"%@-%@, %@", day, monthName, year]];

    }];
}

-(NSString *)hoursFromDate:(NSDate *)date{
    
    NSDate *tempDate = [date toGlobalTime];
    __block  NSString * timeStamp = nil;
    [Utilities dateComponentsFromNSDate:tempDate components:^(NSString* dayName, NSString* monthName, NSString* day, NSString* time, NSString* minutes, NSString * timeAndMinute) {
        timeStamp = [[NSString alloc] initWithString:time];
    }];
    return timeStamp;
}

#pragma mark - Navigation
/*
-(void)btnCourseUpdatesTap{

    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    CourseUpdatesViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseUpdatesViewController"];
    [delegate.appDelegateNavController pushViewController:controller animated:YES];
}

- (IBAction)btnFoodBevTapped:(UIButton *)sender {
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    FoodBeveragesMainViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodBeveragesMainViewController"];
    [delegate.appDelegateNavController pushViewController:controller animated:YES];
}

#pragma mark - NavBarButtonsDelegate

- (IBAction)btnCheckedInTapped:(UIButton *)sender {
    
    [SharedManager sharedInstance].delegate = self;
    
    [[[UIAlertView alloc] initWithTitle:@"CHECKING IN." message:@"Thank you for checking in. Please wait until we get your location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
    if ([CourseServices currentCourse]) {
            [self checkInToCurrentCourse];
    }else{
        [self loadCourseDetailsCompletionBlock:^(Course *currentCourse) {
                [self checkInToCurrentCourse];
        }];
    }
}
*/

-(void)checkInToCurrentCourse{
    
    SharedManager * manager = [SharedManager sharedInstance];
    [manager triggerLocationServices];
    manager.delegate = self;
}

#pragma mark - SharedManagerDelegate for location service.
-(void)IsUserInCourseWithRequiredAccuracy:(BOOL)yesNo{
        
    if (yesNo) {
        [CourseServices checkInToCurrentCourse:^(bool status, id responseObject) {
            if (status) {
                [[[UIAlertView alloc]initWithTitle:@"Success" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        } failure:^(bool status, NSError * error) {
            if (status) {
                [[[UIAlertView alloc]initWithTitle:@"Try Again" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }];
    }else{
        NSString * message = [NSString stringWithFormat:@"You are not inside the course perimeter."];
        [[[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    [SharedManager sharedInstance].delegate = nil;
}

#pragma mark - Invitation

-(void)displayAlertForPendingInvitations{
    
    if ([[GameSettings sharedSettings] invitationToken]) {
        if ([UserServices currentToken]) {
            //TODO: Send call to get invitation details. Some later version
            [[[UIAlertView alloc] initWithTitle:@"Invitation Received" message:@"Accept Invitation to play round." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (buttonIndex) {
        case 0: {// Cancel
            // do nothing just ignore & remove the invitation token from app.
            [[GameSettings sharedSettings] deleteInvitation];
           // [[GameSettings sharedSettings]setInvitationStatusAccepted:NO];
            break;
        }
        case 1:{ // Accept Invitation. Navigate
          //  [[InvitationManager sharedInstance] setInvitationStatusAccepted:YES];
            AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            if ([[appdelegate.appDelegateNavController topViewController] isKindOfClass:[ClubHouseContainerVC class]]) {
                AddPlayersViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlayersViewController"];
                [appdelegate.appDelegateNavController pushViewController:controller animated:YES];
            }else{
                [[[UIAlertView alloc] initWithTitle:nil message:@"Please Navigate to Round Options Screen to Start Round" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Helper
-(CGFloat)minutesBetween:(NSDate *)startDate endDate:(NSDate *)endDate{
    return [endDate timeIntervalSinceDate:startDate] / 60.0;
}
- (IBAction)btnMemberLoginTap:(id)sender {
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    InitialViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [delegate.appDelegateNavController pushViewController:controller animated:YES];
}

- (IBAction)btnEventsCalendarTap:(id)sender {
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    EventCalendarViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EventCalendarViewController"];
    [delegate.appDelegateNavController pushViewController:controller animated:YES];
}

- (IBAction)btnContactUsTap:(id)sender {
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    ContactUsViewController * contactController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
    [delegate.appDelegateNavController pushViewController:contactController animated:YES];
    return;
}
- (IBAction)btnTeeTimeTap:(id)sender {
    
    TeeTimesViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TeeTimesViewController"];
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.appDelegateNavController pushViewController:controller animated:YES];
}


#pragma mark - Memory Management
-(void)dealloc{
    [SharedManager sharedInstance].delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
