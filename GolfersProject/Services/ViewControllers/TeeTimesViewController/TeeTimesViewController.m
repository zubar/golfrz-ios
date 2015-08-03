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

@interface TeeTimesViewController ()
@property(nonatomic, strong) NSMutableArray * subCourses;
@property(nonatomic, strong) NSNumber * selectedSubcourseId;
@property(nonatomic, strong) NSMutableDictionary * teeTimesData;
@property(nonatomic, strong) NSDate * selectedDate;
@end

@implementation TeeTimesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TEE TIMES";
    
    if(!self.subCourses) self.subCourses = [[NSMutableArray alloc] init];
    if(!self.teeTimesData) self.teeTimesData = [[NSMutableDictionary alloc] init];
    
    // Do any additional setup after loading the view.
    SharedManager * manager = [SharedManager sharedInstance];
    self.lblCourseName.text = [manager courseName];
    [self.imgCourseLogo sd_setImageWithURL:[NSURL URLWithString:manager.logoImagePath] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgCourseLogo setRoundedImage:image];
        }
    }];
    
    [self loadSubcourses:^(NSArray *array) {
        if([self.subCourses count] <= 0) [self.subCourses removeAllObjects];
        [self.subCourses addObjectsFromArray:array];
        SubCourse * firstSubCourse = self.subCourses[0];
        self.lblSubCourseName.text = [firstSubCourse name];
        self.selectedSubcourseId = [firstSubCourse itemId];
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
    [self updateTeeTimesForDate:self.selectedDate completion:^{
        [self.teeTimesTable reloadData];
    }];
}

-(void)updateTeeTimesForDate:(NSDate *)teeTimeDate completion:(void(^)(void))completionHandler{
    
    /*
     1: Get all teeTimes from 6:30 to 18:30 with intervals of 7min. 
     2: Get & existing teeTimes from server & remove these times from created teeTimes. 
     3: Sort the teeTimes. 
     4: Assign these times against the teeTimeDate. 
     5: Reload UI on completion.
     */
    NSDate * start = [NSDate NSDateForRFC3339DateTimeString:@"2015-07-13T06:00:00.540Z"];
    NSDate * end = [NSDate NSDateForRFC3339DateTimeString:@"2015-07-13T18:00:00.540Z"];
    [self loadTeetimesStartdate:start endDate:end subCourse:[NSNumber numberWithInt:1] completion:^(NSArray * bookedTeeTimes) {

        
       NSMutableArray * teeTimes = [[self createTeeTimesForDate:teeTimeDate] mutableCopy];
       NSArray * mergedTeeTimes = [self removeExistingTeeTimesFromArray:teeTimes whichAreIn:bookedTeeTimes];
        
        NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"bookedTime" ascending:YES];
        mergedTeeTimes = [mergedTeeTimes sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        [self.teeTimesData setObject:mergedTeeTimes forKey:[teeTimeDate dateWithTimeComponentsZeroSet]];
        completionHandler();
    }];
}

-(NSArray *)createTeeTimesForDate:(NSDate *)teetimeDay{

    //Array
    NSMutableArray * teeTimes = [[NSMutableArray alloc] initWithCapacity:102];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDate *today = [[NSDate alloc] initWithTimeInterval:0 sinceDate:teetimeDay];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
   
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:today];
    comps.hour   = 06;
    comps.minute = 30;
    comps.second = 00;
    NSDate *teeTimeStart = [gregorian dateFromComponents:comps];
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
        NSLog(@"TeeTime: %d StartTime: %@", i, [timeStampTeeTime toLocalTime]);
        
        NSDictionary * teeTimeParam = @{
                                        @"bookedTime" : [timeStampTeeTime toLocalTime],
                                        @"subCourseId" : [NSNumber numberWithInt:1], //TODO: For Testing.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"TeeTimeBookingCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TeeTimeBookingCell"];
    }
    NSArray * teeTimesArray = [self.teeTimesData objectForKey:[self.selectedDate dateWithTimeComponentsZeroSet]];
    Teetime * teeTime = teeTimesArray[indexPath.row];
    TeeTimeBookingCell *customViewCell = (TeeTimeBookingCell *)customCell;
    
    [Utilities dateComponentsFromNSDate:[teeTime bookedTime] components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute) {
        [customViewCell.lblTime setText:timeAndMinute];
    }];
    [customViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [customViewCell setDidTapButtonBlock:^(id sender) {
        // TODO: call book service.
    }];
    return customViewCell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIActions

- (IBAction)btnShowCalendarTapped:(UIButton *)sender {
    
    [ActionSheetDatePicker showPickerWithTitle:@"Select Date"
                                datePickerMode:UIDatePickerModeDateAndTime
                                  selectedDate:self.selectedDate
                                   minimumDate:[NSDate date]
                                   maximumDate:nil
    doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        [Utilities dateComponentsFromNSDate:selectedDate components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute) {
                 [self.lblSelectedDate setText:[NSString stringWithFormat:@"%@, %@ %@", dayName, day, monthName]];
            [self setSelectedDate:selectedDate];
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
                                           [self updateTeeTimesForDate:self.selectedDate completion:^{
                                               [self.teeTimesTable reloadData];
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

-(void)bookTeeTime:(Teetime *)teetime completion:(void(^)(void))completion{
    
}
#pragma mark - MemoryManagement 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
