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


@interface TeeTimesViewController ()
@property(nonatomic, strong) NSMutableArray * subCourses;
@property(nonatomic, strong) NSNumber * selectedSubcourseId;
@end

@implementation TeeTimesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.subCourses) self.subCourses = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
    SharedManager * manager = [SharedManager sharedInstance];
    self.lblCourseName.text = [manager courseName];
    [self.imgCourseLogo sd_setImageWithURL:[NSURL URLWithString:manager.logoImagePath] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgCourseLogo setRoundedImage:image];
        }
    }];
    
    [self loadSubcourses:^(NSArray *array) {
        [self.subCourses removeAllObjects];
        [self.subCourses addObjectsFromArray:array];
        SubCourse * firstSubCourse = self.subCourses[0];
        self.lblSubCourseName.text = [firstSubCourse name];
        self.selectedSubcourseId = [firstSubCourse itemId];
    }];
    
    // Set default date
    [Utilities dateComponentsFromNSDate:[NSDate date] components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute) {
        [self.lblSelectedDate setText:[NSString stringWithFormat:@"%@, %@ %@", dayName, day, monthName]];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
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

-(void)loadTeetimesStartdate:(NSDate *)startDate
                     endDate:(NSDate *)enddate
                   subCourse:(NSNumber *)subcourseId
                  completion:(void(^)(void))completion
{
    //TODO: for testing setting the subcourse id to 1
    [TeetimeServices getTeetimesForSubcourse:[NSNumber numberWithInt:1] success:^(bool status, TeetimeData *dataTees) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(bool status, GolfrzError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"TeeTimeBookingCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TeeTimeBookingCell"];
    }
    
    TeeTimeBookingCell *customViewCell = (TeeTimeBookingCell *)customCell;
   
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

- (IBAction)btnShowCalendarTapped:(UIButton *)sender {
    
    [ActionSheetDatePicker showPickerWithTitle:@"Select Date"
                                datePickerMode:UIDatePickerModeDateAndTime
                                  selectedDate:[NSDate date]
                                   minimumDate:[NSDate date]
                                   maximumDate:nil
    doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        [Utilities dateComponentsFromNSDate:selectedDate components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute) {
                 [self.lblSelectedDate setText:[NSString stringWithFormat:@"%@, %@ %@", dayName, day, monthName]];
        }];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
      //  keep chill. 
    } origin:sender];
    
}

- (IBAction)btnSubcourseTapped:(id)sender {
    
    // No subcourses loaded.
    if (!self.subCourses || [self.subCourses count] <= 0) {
        [self loadSubcourses:^(NSArray *array) {
            [self.subCourses removeAllObjects];
            [self.subCourses addObjectsFromArray:array];
            
        }];
    }else{ // Subcourses are already loaded.
        NSArray *subcourseNames = [self.subCourses valueForKeyPath:@"@distinctUnionOfObjects.name"];
        [ActionSheetStringPicker showPickerWithTitle:@"Select Subcourse"
                                                rows:subcourseNames
                                    initialSelection:0
        doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            SubCourse * selectedCourse = self.subCourses[selectedIndex];
            self.lblSubCourseName.text = [selectedCourse name];
            self.selectedSubcourseId = [selectedCourse itemId];

        } cancelBlock:^(ActionSheetStringPicker *picker) {
          //  keep chill
        } origin:self.view];
    }
}
@end
