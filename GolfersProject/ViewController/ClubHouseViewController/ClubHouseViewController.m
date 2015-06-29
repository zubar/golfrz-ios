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

#import "WEPopoverController.h"
#import "ScoreSelectionContentController.h" //for testing
#import "RoundViewController.h"

@interface ClubHouseViewController ()
@property (nonatomic, retain) NSArray * weatherList;
@end

@implementation ClubHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 22, 22)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"contactus_button"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(btnContactUsTap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton * imageRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 22, 22)];
    [imageRightButton setBackgroundImage:[UIImage imageNamed:@"activity_icon"] forState:UIControlStateNormal];
    [imageRightButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageRightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
   
    NSDictionary *titleAttributes =@{
                                    NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.0],
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                    };
    
    self.navigationController.navigationBar.titleTextAttributes = titleAttributes;
    [[self navigationItem] setTitle:@"CLUBHOUSE"];
    
    
    // Do any additional setup after loading the view.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WeatherServices weatherInfo:^(bool status, NSArray *mWeatherData) {
        if (status) {
            self.weatherList = mWeatherData;
            [self.weatherCollectionView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(bool status, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[[UIAlertView alloc]initWithTitle:@"Try Again" message:@"Failed to get weather" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
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
    } failure:^(bool status, NSError *error) {
        //
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
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    UIPageControl * pageControl = (UIPageControl *)[self.navigationController.navigationBar viewWithTag:89];
    if (pageControl && ![self isKindOfClass:[ClubHouseSubController class]]) {
        [pageControl setHidden:YES];
    }else{
        [pageControl setHidden:NO];
    }
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

-(NSString *)hoursFromDate:(NSDate *)date{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h a"];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    return formattedDateString;
    
}

#pragma mark - Navigation

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnCheckedInTapped:(UIButton *)sender {
    
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

-(void)IsUserInCourseWithRequiredAccuracy:(BOOL)yesNo{
    
    if (yesNo) {
        [CourseServices checkInToCurrentCourse:^(bool status, id responseObject) {
            if (status) {
                [[[UIAlertView alloc]initWithTitle:@"Success" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
        } failure:^(bool status, NSError * error) {
            if (status) {
                [[[UIAlertView alloc]initWithTitle:@"Try Again" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
        }];
    }else{
        NSString * message = [NSString stringWithFormat:@"You are not %d meter inside the course perimeter.",kAccuracyGPS];
        [[[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    

}

-(void)enableCheckInButton:(BOOL)yesNo{
    [self.btnCheckIn setHidden:yesNo];
}

- (IBAction)btnTeeTimeTap:(id)sender {
    
    
    RoundViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    
    
    /*
    ScoreSelectionContentController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreSelectionContentController"];
    CGRect frame = CGRectMake(0, 0, 320, 55);
    [contentViewController.view setFrame:frame];
    
    contentViewController.delegate = nil;
    contentViewController.dataSource = self;
    
    [self.navigationController pushViewController:contentViewController animated:YES];
    
    
    
    
    
    WEPopoverController * popoverController  = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
   
    [popoverController setContainerViewProperties:[self improvedContainerViewProperties]];
    popoverController.delegate = self;



    [popoverController presentPopoverFromRect:button.frame
                                       inView:self.view
                     permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown)
                                     animated:YES];
    */

}

 // TODO: Testing code
-(NSArray *)dataArrayForCells{
    
    return [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
}

-(void)selectedItemForCell:(id)item{
    
    
}

- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
    
    WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] init];
    NSString *bgImageName = nil;
    CGFloat bgMargin = 0.0;
    CGFloat bgCapSize = 0.0;
    CGFloat contentMargin = 4.0;
    
    bgImageName = @"popoverBg.png";
    
    // These constants are determined by the popoverBg.png image file and are image dependent
    bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13
    bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
    
    props.leftBgMargin = bgMargin;
    props.rightBgMargin = bgMargin;
    props.topBgMargin = bgMargin;
    props.bottomBgMargin = bgMargin;
    props.leftBgCapSize = bgCapSize;
    props.topBgCapSize = bgCapSize;
    props.bgImageName = bgImageName;
    props.leftContentMargin = contentMargin;
    props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
    props.topContentMargin = contentMargin;
    props.bottomContentMargin = contentMargin;
    
    props.arrowMargin = 4.0;
    
    props.upArrowImageName = @"popoverArrowUp.png";
    props.downArrowImageName = @"popoverArrowDown.png";
    props.leftArrowImageName = @"popoverArrowLeft.png";
    props.rightArrowImageName = @"popoverArrowRight.png";
    return props;	
}

@end
