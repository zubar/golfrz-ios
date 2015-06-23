//
//  EventCalendarViewController.m
//  GolfersProject
//
//  Created by Zubair on 5/27/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "EventCalendarViewController.h"
#import "VRGCalendarView.h"
#import "CalendarEventServices.h"
#import "CalendarEventCell.h"
#import "CalendarEvent.h"
#import "NSDate+Helper.h"
#import "EventDetailViewController.h"
#import "MBProgressHUD.h"
#import "GolfrzErrorResponse.h"
#import "GolfrzError.h"
#import "EventHeaderView.h"
#import "AppDelegate.h"
#import "ClubHouseSubController.h"
#import "Utilities.h"
#import "WeatherServices.h"
#import <SDWebImage/UIImageView+WebCache.h>


#define kEventCalendarMarginLeft 10.0f
#define kEventCalendarMarginTop 60.0f
#define kEventCalendarWidth 300.0f // please it also depends on calendar height in VrgCalendar.h
#define kEventCalendarHeight 320.0f

@interface EventCalendarViewController ()

//To mark the dates in calendar
@property (nonatomic, retain) NSMutableArray * eventDates;
@property (nonatomic, retain) NSMutableArray * colors;

//To populate today events in table
@property (nonatomic, retain) NSMutableArray * todayEvents;

@end

@implementation EventCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];

    [imageButton addTarget:self action:@selector(backBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    NSDictionary *navTitleAttributes =@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                        NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.0],
                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                        };

    
    self.navigationItem.title = @"EVENT CALENDAR";
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    
    self.calendar = [[VRGCalendarView alloc] init];
    [self.calendar setFrame:CGRectMake(kEventCalendarMarginLeft, kEventCalendarMarginTop, kEventCalendarWidth, kEventCalendarHeight)];
    [self.calendar setBackgroundColor:[UIColor clearColor]];
    
    [self.calendar setDelegate:self];
    [self.view addSubview:self.calendar];
    
    self.eventsTableVeiw = [[UITableView alloc]initWithFrame:CGRectMake(kEventCalendarMarginLeft, 22 + kEventCalendarHeight  , kEventCalendarWidth - 4, appFrame.size.height - self.eventsTableVeiw.frame.origin.y) style:UITableViewStylePlain];
    
    [self.eventsTableVeiw setBackgroundColor:[UIColor clearColor]];
    [self.eventsTableVeiw setBackgroundView:nil];
    [self.eventsTableVeiw setHidden:YES];
    self.eventsTableVeiw.dataSource = self;
    self.eventsTableVeiw.delegate = self;
    [self.view addSubview:self.eventsTableVeiw];
    
    [self initializeDataStructures];
    [self fetchEvents];

    
}

-(void)viewWillAppear:(BOOL)animated{

    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-10.0 forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:YES];
    
}

-(void)initializeDataStructures{
    
    if (!self.eventDates) {
        self.eventDates = [[NSMutableArray alloc]init];}
    if (!self.colors) {
        self.colors = [[NSMutableArray alloc]init];}
    if (!self.todayEvents) {
        self.todayEvents = [[NSMutableArray alloc]init];
    }
}

-(void)reloadCalendarAndEventTable{
    [self.calendar reset];
    [self.calendar markDates:self.eventDates withColors:self.colors];
    [self.eventsTableVeiw reloadData];
}

-(void)updateAllDataStructures{


}

-(void)fetchEvents{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CalendarEventServices getEvents:^(bool status, EventList *eventsArray) {
        if (status) {
            self.eventslist = eventsArray;
            [self reloadCalendarAndEventTable];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(bool status, NSError *error) {
        if (!status) {
            NSLog(@"Error");
            [MBProgressHUD hideHUDForView:self.view animated:YES];

        }
    }];
}


#pragma mark - VRGCalendarView Delegate
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated{
    
    [self updateCalendarEventTableViewForCalenderHeight:targetHeight];
    
    
    NSDateComponents *yourDate = [NSDateComponents new];
    yourDate.calendar = [NSCalendar currentCalendar];
    yourDate.year  = 2015;
    yourDate.month = month;
    yourDate.day   = 1;
    
    NSDate *startDate = [yourDate date];
    // Add one day to the previous date. Note that  1 day != 24 h
    NSDateComponents *oneDay = [NSDateComponents new];
    oneDay.day = 30;
    // one day after begin date
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:oneDay
                                                                    toDate:startDate
                                                                   options:0];
    
    [self updateEventsStartDate:startDate endDate:endDate];
    [self.calendar markDates:self.eventDates withColors:self.colors];
}

-(void)updateCalendarEventTableViewForCalenderHeight:(float)height{
    
    CGRect  appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect finalFrame =  CGRectMake(kEventCalendarMarginLeft, height + 61 , kEventCalendarWidth - 4, appFrame.size.height - height - 41);
    [UIView animateWithDuration:0.35 animations:^{
        [self.eventsTableVeiw setFrame:finalFrame];
    }];
}

-(void)updateEventsStartDate:(NSDate * )startDate endDate:(NSDate *)endDate{
   
    // Predicate for all dates between startDate and endDate
    if (self.eventslist) {
        NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"dateStart >= %@ AND dateStart < %@",startDate, endDate];
        NSArray * temp = [[self.eventslist.items filteredArrayUsingPredicate:datePredicate] mutableCopy];
        
        self.eventDates = [temp valueForKeyPath:@"@distinctUnionOfObjects.dateStart"];
        for (CalendarEvent * calEvent in temp) {
            NSLog(@"%@", calEvent.dateStart);
            [self.colors addObject:[UIColor redColor]];
        }
    }

}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{

    
    NSDateComponents * selectedDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    NSDateComponents *todayComponents = [NSDateComponents new];
    todayComponents.calendar = [NSCalendar currentCalendar];
    todayComponents.year  = selectedDateComponents.year;
    todayComponents.month = selectedDateComponents.month;
    todayComponents.day   = selectedDateComponents.day;
    
    NSDate * today = [todayComponents date];

    NSDateComponents *oneDay = [NSDateComponents new];
    oneDay.day = 30;
    // one day after begin date
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:oneDay
                                                                    toDate:today
                                                                   options:0];
    
    
    if (self.eventslist) {
        NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"dateStart >= %@ AND dateStart < %@",today, endDate];
        self.todayEvents = [[self.eventslist.items filteredArrayUsingPredicate:datePredicate] mutableCopy];
        if ([self.todayEvents count] > 0) {
            [self.lblNoEvents setHidden:YES];
            [self.eventsTableVeiw setHidden:NO];
        }else{
            [self.lblNoEvents setHidden:NO];
            [self.eventsTableVeiw setHidden:YES];
        }
        [self.eventsTableVeiw reloadData];
    }
}


#pragma mark - CalendarEventCellDelegate

-(void)tappedDetailedDisclosueForEvent:(CalendarEvent *)event{

    [self performSegueWithIdentifier:@"segueToEventDetailController" sender:event];
}


#pragma mark - UITableViewController DataSource & Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.todayEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *cellIdentifier = @"calendarCellIdentifier";
    
    CalendarEventCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CalendarEventCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    CalendarEvent * eventObject = [self.todayEvents objectAtIndex:indexPath.row];
    [cell configureViewWithEvent:eventObject];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    cell.delegate = self;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CalendarEvent * eventObject = [self.todayEvents objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueToEventDetailController" sender:eventObject];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CalendarEventCellHeight;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    EventHeaderView * headerView = [[EventHeaderView alloc]init];
    [headerView.imgWeather setHidden:YES];
    [headerView.lblTemperature setHidden:YES];

    
    
    
    if ([self.calendar selectedDate]) 
    [Utilities dateComponentsFromNSDate:[self.calendar selectedDate] components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString * minutes) {
        [headerView.lblDate setText:[[NSString stringWithFormat:@"%@, %@ %@", dayName, monthName, day] uppercaseString]];
        [headerView.lblDate setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        
        [WeatherServices dailyWeather:^(bool status, NSDictionary *weatherData) {
            if (status) {
                [headerView.imgWeather sd_setImageWithURL:weatherData[@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    //  <#code#>
                    [headerView.imgWeather setImage:image];
                    [headerView.imgWeather setHidden:NO];
                } ];
                
                [headerView.lblTemperature setText:[NSString stringWithFormat:@"%@ C", [weatherData[@"temp"] stringValue]]];
                [headerView.lblTemperature setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];

                [headerView.lblTemperature setHidden:NO];
            }
        } failure:^(bool status, NSError *error) {
            if (!status) {
                [headerView.imgWeather setHidden:YES];
                [headerView.lblTemperature setHidden:YES];
            }
        }];
        
    }];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.0f;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString: @"segueToEventDetailController"]) {
        EventDetailViewController *dest = (EventDetailViewController *)[segue destinationViewController];
        dest.currentEvent=sender;
    }
}

-(void)backBtnTapped{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController popViewControllerAnimated:YES];
}

#pragma mark - MemoryManagement 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
