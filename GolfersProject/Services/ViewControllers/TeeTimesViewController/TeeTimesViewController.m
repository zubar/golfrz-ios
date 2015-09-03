//
//  TeeTimesViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/8/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "TeeTimesViewController.h"
#import "TeeTimeBookingCell.h"
#import "TeetimeServices.h"
#import "MBProgressHUD.h"
#import "GameSettings.h"
#import "CourseServices.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "Utilities.h"
#import "CourseServices.h"
#import "SharedManager.h"
#import "Course.h"
#import "SubCourse.h"
#import "GolfrzError.h"
#import "RoundMetaData.h"
#import "RoundDataServices.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+RoundedImage.h"
#import "TeetimeData.h"
#import "NSDate+Helper.h"
#import "NSDate+convenience.h"
#import "AppDelegate.h"
#import "Teetime.h"
#import "NSArray+BinarySearch.h"
#import "Utilities.h"
#import "ScoreSelectionView.h"
#import <CMPopTipView/CMPopTipView.h>
#import "ScoreSelectionCell.h"
#import "WeatherServices.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TeeTimesViewController ()
@property(nonatomic, strong) NSMutableArray * subCourses;
@property(nonatomic, strong) NSNumber * selectedSubcourseId;
@property(nonatomic, strong) NSMutableDictionary * teeTimesData;
@property(nonatomic, strong) NSDate * selectedDate;
@property(nonatomic, strong) CMPopTipView * popTipView;

@property(nonatomic, strong) UIButton * tappedButton;
@end

@implementation TeeTimesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];

    self.navigationItem.title = @"TEE TIMES";
    
    if(!self.subCourses) self.subCourses = [[NSMutableArray alloc] init];
    if(!self.teeTimesData) self.teeTimesData = [[NSMutableDictionary alloc] init];
    
    // Do any additional setup after loading the view.
    self.lblCourseName.text = [manager courseName];
    [self.imgCourseLogo sd_setImageWithURL:[NSURL URLWithString:manager.logoImagePath] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgCourseLogo setRoundedImage:image];
        }
    }];
    // Set default date
    if(! self.selectedDate){
        [self setSelectedDate:[NSDate date]];
    }
    [Utilities dateComponentsFromNSDate:self.selectedDate components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute) {
        [self.lblSelectedDate setText:[NSString stringWithFormat:@"%@, %@ %@", dayName, day, monthName]];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self loadSubcourses:^(NSArray *array) {
        if([self.subCourses count] <= 0) [self.subCourses removeAllObjects];
        [self.subCourses addObjectsFromArray:array];
        SubCourse * firstSubCourse = self.subCourses[0];
        self.lblSubCourseName.text = [firstSubCourse name];
        self.selectedSubcourseId = [firstSubCourse itemId];
        
        // Get teetimes after loading subcourses.
        [self updateTeeTimesForDate:self.selectedDate completion:^{
            [self.teeTimesTable reloadData];
        }];
    }];
    
   
}
-(void)updateWeatherForDate:(NSDate *)timeStamp{
    
    [WeatherServices dailyWeather:^(bool status, NSDictionary *weatherData) {
        NSString * weatherTemp = weatherData[@"temp"];
        if(!weatherTemp || (weatherData[@"temp"] == [NSNull null])){
            [self.lblTemperature setHidden:YES];
            [self.imgWeatherImage setHidden:YES];
        }else{
            [self.imgWeatherImage sd_setImageWithURL:weatherData[@"icon"] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self.imgWeatherImage setImage:image];
            }];
            [self.lblTemperature setText:[NSString stringWithFormat:@"%@ F", weatherTemp]];
            [self.lblTemperature setHidden:NO];
            [self.imgWeatherImage setHidden:NO];
        }
    } failure:^(bool status, NSError *error) {
        [self.imgWeatherImage setHidden:YES];
        [self.lblTemperature setHidden:YES];
    }];
}

-(void)updateTeeTimesForDate:(NSDate *)teeTimeDate completion:(void(^)(void))completionHandler{
    
    [self updateWeatherForDate:teeTimeDate];
    
    /*
     1: Get all teeTimes from 6:30 to 18:30 with intervals of 7min. 
     2: Get & existing teeTimes from server & remove these times from created teeTimes. 
     3: Sort the teeTimes. 
     4: Assign these times against the teeTimeDate. 
     5: Reload UI on completion.
     */
    
    NSDate * tempStart = [NSDate dateWithTimeInterval:0 sinceDate:self.selectedDate];
    NSDate * start =  [[[tempStart dateWithTimeComponentsZeroSet] toLocalTime] dateWithOffsethours:6 minuteOffset:30];
    NSDate * tempEnd = [NSDate dateWithTimeInterval:0 sinceDate:self.selectedDate];
    NSDate * end =  [[[tempEnd dateWithTimeComponentsZeroSet] toLocalTime] dateWithOffsethours:18 minuteOffset:30];
    
    
    [self loadTeetimesStartdate:start endDate:end subCourse:self.selectedSubcourseId completion:^(NSArray * serverBookedTimes) {
        
       NSMutableSet * teeTimes = [self createTeeTimesForDate:teeTimeDate];
       NSSet * bookedTeetimes = [NSSet setWithArray:serverBookedTimes];
        
      [teeTimes minusSet:bookedTeetimes];
      [teeTimes unionSet:bookedTeetimes];
        
        
        NSArray * mergedTeeTimes = [[NSMutableArray alloc] initWithArray:[teeTimes allObjects]];

        NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"bookedTime" ascending:YES];
        mergedTeeTimes = [mergedTeeTimes sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        [self.teeTimesData setObject:mergedTeeTimes forKey:[teeTimeDate dateWithTimeComponentsZeroSet]];
        completionHandler();
    }];
}

-(NSMutableSet *)createTeeTimesForDate:(NSDate *)teetimeDay{

    //Array
    NSMutableSet * teeTimes = [[NSMutableSet alloc]init];
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];

    NSDate *today = [[NSDate alloc] initWithTimeInterval:0 sinceDate:teetimeDay];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
   
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:today];
    comps.hour   = 06;
    comps.minute = 30;
    comps.second = 00;
    NSDate *teeTimeStart = [[gregorian dateFromComponents:comps] toLocalTime];
    NSLog(@"%@", teeTimeStart);
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    //[offsetComponents setMonth:-1]; // note that I'm setting it to -1
    [offsetComponents setMinute:00];
    [offsetComponents setHour:00];
    [offsetComponents setSecond:00];
    
    // Tee times start
    for (int i = 1; i <= 103; ++i) {
        NSDate *timeStampTeeTime = [gregorian dateByAddingComponents:offsetComponents toDate:teeTimeStart options:0];
        [offsetComponents setMinute:i * 7];
        NSLog(@"TeeTime: %d StartTime: %@", i, timeStampTeeTime);
        
        NSDictionary * teeTimeParam = @{
                                        @"bookedTime" : timeStampTeeTime,
                                        @"subCourseId" : self.selectedSubcourseId, 
                                        //propertyName : json_key
                                        };
        
        NSError * timeError = nil;
        Teetime * teeTime = [Teetime modelWithDictionary:teeTimeParam error:&timeError];
        if (!timeError) [teeTimes addObject:teeTime];
    }
    return teeTimes;
}

/*
 Always pass the created tee times in arrayOne.
 */
-(NSArray *)removeExistingTeeTimesFromArray:(NSMutableArray *)arrayOne whichAreIn:(NSArray *)arrayTwo{
    
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"bookedTime" ascending:YES];
    arrayOne = [[arrayOne sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    arrayTwo = [arrayTwo sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    
    assert([arrayOne count] >= [arrayTwo count]);
    
    for (int i = 0; i < [arrayOne count]; --i) {
        Teetime * createdTeetime = arrayOne[i];
        
        NSInteger index = [arrayTwo binarySearch:createdTeetime];
        if (index != NSNotFound) {
            [arrayOne replaceObjectAtIndex:i withObject:arrayTwo[index]];
        }
    }
    return arrayOne;
}


-(void)loadSubcourses:(void(^)(NSArray * array))subCourses{
    
    // load golf  course & its sub courses.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RoundDataServices getRoundData:^(bool status, RoundMetaData *date) {
        if (status){
            subCourses([date subCourses]);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(bool status, GolfrzError *error) {
        if (!status){
            [Utilities displayErrorAlertWithMessage:[error errorMessage]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![self.teeTimesData objectForKey:[self.selectedDate dateWithTimeComponentsZeroSet]]) {
        return 0;
    }
    NSArray * teeTimesArray = [self.teeTimesData objectForKey:[self.selectedDate dateWithTimeComponentsZeroSet]];
    return [teeTimesArray count];
}

- (void)bookTeetimeForPlayers:(NSInteger)playerCount tee:(Teetime *)tee
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(![tee itemId]) //teetime is never book
        [TeetimeServices bookTeeTimeSubcourse:self.selectedSubcourseId playersNo:[NSNumber numberWithInteger:playerCount] bookTime:[tee bookedTime] success:^(bool status, Teetime * response) {
            // Reload all the teetimes
            if(status){
                [self showAlertBookedTeetimeOnDate:response];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                [self updateTeeTimesForDate:self.selectedDate completion:^{
                    [self.teeTimesTable reloadData];
                }];
            }
        } failure:^(bool status, GolfrzError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [Utilities displayErrorAlertWithMessage:[error errorMessage]];
        }];
    else
        [[[UIAlertView alloc] initWithTitle:@"Tee Time Already Booked!" message:@"This tee time is already booked please contact course admin." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"TeeTimeBookingCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TeeTimeBookingCell"];
    }
        __block NSArray * teeTimesArray = [self.teeTimesData objectForKey:[self.selectedDate dateWithTimeComponentsZeroSet]];
    Teetime * teeTime = teeTimesArray[indexPath.row];
    
    TeeTimeBookingCell *customViewCell = (TeeTimeBookingCell *)customCell;
    [customViewCell updateViewBtnForTeetime:teeTime];
    
    [Utilities dateComponentsFromNSDate:[teeTime bookedTime] components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute) {
        [customViewCell.lblTime setText:timeAndMinute];
    }];
    
    
    [customViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [customViewCell setDidTapButtonBlock:^(id sender , NSInteger playerCount) {
        // Update the tee time if already existing teeTime persons are
        NSIndexPath * indexOfTappedBtn = nil;
        if([sender isKindOfClass:[TeeTimeBookingCell class]]) indexOfTappedBtn = [self.teeTimesTable indexPathForCell:sender];
       
        Teetime * tee = [teeTimesArray objectAtIndex:indexOfTappedBtn.row];
        if([teeTime itemId] != nil){
            [self displayTeetimeAlreadyBookedAlert];
        }else{
            if(playerCount <= 0) [self displayAlertPlayerCountZero];
            else [self bookTeetimeForPlayers:playerCount tee:tee];
        }

    }];
    [customViewCell setDidTapPlayerCountBtnBlock:^(id sender ) {
        [self editTeetimeTappedFromView:sender];
    }];
    return customViewCell;
}

#pragma mark - Pop-up view

// To enter score manually for a player.
-(void)editTeetimeTappedFromView:(id)sender
{
    ScoreSelectionView * mScoreView = [[ScoreSelectionView alloc]init];
    mScoreView.dataSource = self;
    mScoreView.delegate = self;
    [mScoreView setBackgroundColor:[UIColor whiteColor]];
    
    // Toggle popTipView when a standard UIButton is pressed
    if (nil == self.popTipView) {
        self.popTipView = [[CMPopTipView alloc] initWithCustomView:mScoreView];
        self.popTipView.delegate = self;
        self.popTipView.backgroundColor = [UIColor whiteColor];
        [self.popTipView setCornerRadius:0.0];
        // saving the ref to selected view.
        self.tappedButton = sender;
        [self.popTipView setDismissTapAnywhere:YES];
        [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
    }else {
        // Dismiss
        [self.popTipView dismissAnimated:YES];
        self.popTipView = nil;
    }
}

-(NSArray *)dataArrayForCells
{
    NSMutableArray * scoresArray = [NSMutableArray new];
    for (int i = 1; i < 6; ++i) {
        [scoresArray addObject:[[NSNumber numberWithInt:i] stringValue]];
    }
    return scoresArray;
}

-(void)selectedItem:(id)item forView:(UIView *)view{
    
    NSLog(@"tapped: %@ indexPath: %@", item, view);
    if ([view isKindOfClass:[ScoreSelectionCell class]]) {
        [self.tappedButton setTitle:item forState:UIControlStateNormal];
        
    }
    self.tappedButton = nil;
    [self.popTipView dismissAnimated:YES];
}

#pragma mark - UIActions

- (IBAction)btnShowCalendarTapped:(UIButton *)sender {
    
    [ActionSheetDatePicker showPickerWithTitle:@"Select Date"
                                datePickerMode:UIDatePickerModeDate
                                  selectedDate:self.selectedDate
                                   minimumDate:[NSDate date]
                                   maximumDate:nil
    doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        [Utilities dateComponentsFromNSDate:selectedDate components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute) {
                 [self.lblSelectedDate setText:[NSString stringWithFormat:@"%@, %@ %@", dayName, day, monthName]];
            [self setSelectedDate:selectedDate];
        }];
        // Get teetimes after loading subcourses.
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self updateTeeTimesForDate:self.selectedDate completion:^{
            [self.teeTimesTable reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
      //  keep chill. 
    } origin:sender];
    
}

- (IBAction)btnSubcourseTapped:(id)sender {
    
    // No subcourses loaded.
    if ([self.subCourses count] <= 0) {
        [self loadSubcourses:^(NSArray *array) {
            if([self.subCourses count] <= 0) [self.subCourses removeAllObjects];
            [self.subCourses addObjectsFromArray:array];
            [self displaySubCoursePicker];
        }];
    }else{
        [self displaySubCoursePicker];
    }
}

-(void)displaySubCoursePicker{
    NSArray *subcourseNames = [self.subCourses valueForKeyPath:@"@distinctUnionOfObjects.name"];
    [ActionSheetStringPicker showPickerWithTitle:@"Select Subcourse"
                                            rows:subcourseNames
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           SubCourse * selectedCourse = self.subCourses[selectedIndex];
                                           self.lblSubCourseName.text = [selectedCourse name];
                                           self.selectedSubcourseId = [selectedCourse itemId];
                                           [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                           [self updateTeeTimesForDate:self.selectedDate completion:^{
                                               [self.teeTimesTable reloadData];
                                               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           }];
                                           
                                       } cancelBlock:^(ActionSheetStringPicker *picker) {
                                           //  keep chill
                                       } origin:self.view];
}

#pragma mark - API-Calls
-(void)loadTeetimesStartdate:(NSDate *)startDate
                     endDate:(NSDate *)enddate
                   subCourse:(NSNumber *)subcourseId
                  completion:(void(^)(NSArray * teetimesArray))completion
{
    [TeetimeServices getTeetimesForSubcourse:subcourseId startDate:startDate endDate:enddate success:^(bool status, TeetimeData *dataTees) {
        if(status) completion(dataTees.teetimes);
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}

#pragma mark - MemoryManagement 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    // User can tap CMPopTipView to dismiss it
    self.popTipView = nil;
}

#pragma mark - ErrorAlerts 

-(void)displayTeetimeAlreadyBookedAlert{
    [[[UIAlertView alloc] initWithTitle:@"Tee Time Already Booked!" message:@"This tee time is already booked, please contact admin to update or cancel booking." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

-(void)displayAlertPlayerCountZero{
    [[[UIAlertView alloc] initWithTitle:@"Player Count Zero!" message:@"A tee time can not be booked for zero player selected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

-(void)showErrorAlert{
    [[[UIAlertView alloc] initWithTitle:@"Can not Update Tee time!" message:@"Number of players for a booked tee time can't be decreased & maximum number of player for a tee time is 5." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

-(void)showAlertBookedTeetimeOnDate:(Teetime *)mTeeTime
{
    __block NSString * message = nil;
    [Utilities dateComponents:[mTeeTime bookedTime] components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute, NSString *year) {
        message = [NSString stringWithFormat:@"Booked Tee Time at %@ on %@ %@, %@ for %@ player.", timeAndMinute, day, monthName, year, [[mTeeTime count] stringValue]];
    }];
    [[[UIAlertView alloc] initWithTitle:@"Tee Time Details." message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
@end
