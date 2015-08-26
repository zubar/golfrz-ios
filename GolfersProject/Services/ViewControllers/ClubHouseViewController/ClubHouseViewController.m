//
//  GreenViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ClubHouseViewController.h"
#import "ClubHouseContainerVC.h"
#import "WeatherViewCell.h"
#import "WeatherServices.h"
#import "MBProgressHUD.h"
#import "UserServices.h"
#import "InvitationServices.h"
#import "AppDelegate.h"
#import "AddPlayersViewController.h"

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

#import "RoundDataServices.h"

#import "RoundViewController.h"
#import "ScoreSelectionView.h"
#import "GameSettings.h"
#import "RoundMoviePlayerController.h"
#import "TeeTimesViewController.h"
#import "HMMessagesDisplayViewController.h"

@interface ClubHouseViewController ()
{
    NSDate * lastWeatherUpdateTime;
}
@property (nonatomic, retain) NSArray * weatherList;
@end

@implementation ClubHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];

    
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
    
    
    // Receive this notification to check if there are any pending invitations to show.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayAlertForPendingInvitations) name:kAppLaunchUserTapInvitationLink object:nil];
    [self  loadCourseDetailsCompletionBlock:^(Course *currentCourse) {
        // Loading course details to use by courseServices, Must call this. 
    }];
    [self loadDataForCurrentCourse];
    
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

-(void)loadCourseDetailsCompletionBlock:(void (^)(Course *currentCourse))completionBlock{
    
    [CourseServices courseDetailInfo:^(bool status, Course *currentCourse) {
        if (status) {
            //TODO: any business logic on it to apply.
            if (status) {
                completionBlock(currentCourse);
            }
        }
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    UIPageControl * pageControl = (UIPageControl *)[self.navigationController.navigationBar viewWithTag:89];
    if (pageControl && ![self isKindOfClass:[ClubHouseSubController class]]) {
        [pageControl setHidden:YES];
    }else{
        [pageControl setHidden:NO];
    }
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-10.0 forBarMetrics:UIBarMetricsDefault];
    
    //Update weatherData
    [self updateWeatherData];
    [self getAvailableFeatures];


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
    
    UIPageControl * pageControl = (UIPageControl *)[self.navigationController.navigationBar viewWithTag:89];
    if (pageControl && ![self isKindOfClass:[ClubHouseSubController class]]) {
        [pageControl setHidden:YES];
    }else{
        [pageControl setHidden:NO];
    }
    [SharedManager sharedInstance].delegate = nil;
}
-(void)btnContactUsTap{

    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    
    ContactUsViewController * contactController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
    [delegate.appDelegateNavController pushViewController:contactController animated:YES];
    return;
}
- (void)pushNextController{
    [self.navigationController pushViewController:self.containerVC.playerProfileViewController animated:YES];
}

/**
 @brief Method gets the enabled features list and show / hides buttons depending on it.
 */

-(void)getAvailableFeatures{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.teeTimesView setHidden:YES];
    [self.eventsView setHidden:YES];
    [self.foodBevView setHidden:YES];
    
    NSMutableDictionary * visibleFeatures = [NSMutableDictionary new];
    
    [CourseServices getEnabledFeatures:^(bool status, NSArray *enabledFeatures) {
        if (status) {
            for (FeaturedControl * featureItem in enabledFeatures) {
                if([[featureItem featureName] isEqualToString:kFeatTeetime] ||
                   [[featureItem featureName] isEqualToString:kFeatEventCalendar] ||
                   [[featureItem featureName] isEqualToString:kFeatFoodAndBeverages])
                    [visibleFeatures setObject:[featureItem featureName] forKey:[featureItem featureName]];
            }
            
            int countFeatureItems = (int)[[visibleFeatures allKeys] count];
            int xDisplacement = self.view.frame.size.width/(countFeatureItems+1);
            int multiplyFactor = 1;
            
                //Adjust View frames
                if ([visibleFeatures objectForKey:kFeatTeetime]) {
                    [self.teeTimesView setCenter:CGPointMake(xDisplacement * multiplyFactor , self.teeTimesView.center.y)];
                    ++multiplyFactor;
                    [self.teeTimesView setHidden:NO];
                    NSLog(@"TeeTime: xDisplacement: %d, countFeatureItem: %d, X-Axis: %d", xDisplacement, countFeatureItems, xDisplacement * multiplyFactor);
                }
                if ([visibleFeatures objectForKey:kFeatEventCalendar]) {
                    [self.eventsView setCenter:CGPointMake(xDisplacement* multiplyFactor, self.eventsView.center.y)];
                    ++multiplyFactor;
                    [self.eventsView setHidden:NO];
                    NSLog(@"FeatEventCal: xDisplacement: %d, countFeatureItem: %d, X-Axis: %d", xDisplacement, countFeatureItems, xDisplacement * multiplyFactor);
                }
                if ([visibleFeatures objectForKey:kFeatFoodAndBeverages]) {
                    [self.foodBevView setCenter:CGPointMake(xDisplacement* multiplyFactor, self.foodBevView.center.y)];
                    ++multiplyFactor;
                    [self.foodBevView setHidden:NO];
                    NSLog(@"FoodBef: xDisplacement: %d, countFeatureItem: %d, X-Axis: %d", xDisplacement, countFeatureItems, xDisplacement * multiplyFactor);
                }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    } failure:^(bool status, GolfrzError *error) {
        // If request fails also show the data in exiting labels.
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    WeatherViewCell *customCell = (WeatherViewCell *)cell;
    [customCell.lblTime setText:[self hoursFromDate:tempWeather.timeStamp]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    NSString *tempToDisplay = [formatter stringFromNumber:tempWeather.temperature];
    [customCell.lblTemperature setText:[NSString stringWithFormat:@"%@", tempToDisplay]];
    
    [customCell.imgWeatherIcon sd_setImageWithURL:[NSURL URLWithString:tempWeather.condition.icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      //  <#code#>
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

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h a"];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    return formattedDateString;
    
}

#pragma mark - Navigation

-(void)btnCourseUpdatesTap{

    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    CourseUpdatesViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseUpdatesViewController"];
    [delegate.appDelegateNavController pushViewController:controller animated:YES];
}

- (IBAction)btnEventsTapped:(id)sender {
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    EventCalendarViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EventCalendarViewController"];
    [delegate.appDelegateNavController pushViewController:controller animated:YES];
}

- (IBAction)btnFoodBevTapped:(UIButton *)sender {
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    FoodBeveragesMainViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodBeveragesMainViewController"];
    [delegate.appDelegateNavController pushViewController:controller animated:YES];
}

#pragma mark - NavBarButtonsDelegate

- (IBAction)btnCheckedInTapped:(UIButton *)sender {
    
    [[[UIAlertView alloc] initWithTitle:@"CHECKING IN." message:@"Thank you for checking in. Please wait until we get your location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
    if ([CourseServices currentCourse]) {
            [self checkInToCurrentCourse];
    }else{
        [self loadCourseDetailsCompletionBlock:^(Course *currentCourse) {
                [self checkInToCurrentCourse];
        }];
    }
}

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
        NSString * message = [NSString stringWithFormat:@"You are not %d meter inside the course perimeter.",kAccuracyGPS];
        [[[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    

}

-(void)enableCheckInButton:(BOOL)yesNo{
    [self.btnCheckIn setHidden:yesNo];
}

- (IBAction)btnTeeTimeTap:(id)sender {
    
    TeeTimesViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TeeTimesViewController"];
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.appDelegateNavController pushViewController:controller animated:YES];
}

#pragma mark - Invitation

-(void)displayAlertForPendingInvitations{
    
    if ([[GameSettings sharedSettings] invitationToken]) {
        if ([UserServices currentToken]) {
            //TODO: Send call to get invitation details.
            
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
-(CGFloat)minutesBetween:(NSDate *)startDate endDate:(NSDate *)endDate
{
    return [endDate timeIntervalSinceDate:startDate] / 60.0;
}

@end
