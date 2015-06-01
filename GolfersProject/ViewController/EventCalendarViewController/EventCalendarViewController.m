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

#define kEventCalendarMarginLeft 10.0f
#define kEventCalendarMarginTop 60.0f
#define kEventCalendarWidth 300.0f // please it also depends on calendar height in VrgCalendar.h
#define kEventCalendarHeight 320.0f

@interface EventCalendarViewController ()

@end

@implementation EventCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpData];
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    
    self.calendar = [[VRGCalendarView alloc] init];
    [self.calendar setFrame:CGRectMake(kEventCalendarMarginLeft, kEventCalendarMarginTop, kEventCalendarWidth, kEventCalendarHeight)];
    [self.calendar setBackgroundColor:[UIColor clearColor]];
    
    [self.calendar setDelegate:self];
    [self.view addSubview:self.calendar];
    
    [self.eventsTableVeiw setBackgroundColor:[UIColor clearColor]];
    [self.eventsTableVeiw setBackgroundView:nil];
    
    self.eventsTableVeiw = [[UITableView alloc]initWithFrame:CGRectMake(kEventCalendarMarginLeft, 22 + kEventCalendarHeight  , kEventCalendarWidth - 4, appFrame.size.height - self.eventsTableVeiw.frame.origin.y) style:UITableViewStylePlain];
    
    self.eventsTableVeiw.dataSource = self;
    self.eventsTableVeiw.delegate = self;
    [self.view addSubview:self.eventsTableVeiw];
    
}

-(void)viewWillAppear:(BOOL)animated{

    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
}

-(void)setUpData{
    
    if (!self.eventDates) {
        self.eventDates = [[NSMutableArray alloc]init];}
    if (!self.colors) {
        self.colors = [[NSMutableArray alloc]init];}
    if (!self.todayEvents) {
        self.todayEvents = [[NSMutableArray alloc]init];
    }
    [self fetchEvents];
}

-(void)fetchEvents{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CalendarEventServices getEvents:^(bool status, EventList *eventsArray) {
        if (status) {
            self.eventslist = eventsArray;
            [self.calendar reset];
            [self.eventsTableVeiw reloadData];
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
        
        //        [self.eventDates removeAllObjects];
        //        [self.colors removeAllObjects];
        
        self.eventDates = [temp valueForKeyPath:@"@distinctUnionOfObjects.dateStart"];
        for (CalendarEvent * calEvent in temp) {
            NSLog(@"%@", calEvent.dateStart);
            [self.colors addObject:[UIColor redColor]];
        }
        [self.calendar markDates:self.eventDates withColors:self.colors];
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
        [self.eventsTableVeiw reloadData];
    }
}

-(void)updateTodayEvents{


}

#pragma mark - CalendarEventCellDelegate

-(void)tappedDetailedDisclosueForEvent:(CalendarEvent *)event{

    [self performSegueWithIdentifier:@"segueToEventDetailController" sender:event];
}


#pragma mark - UITableViewController

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CalendarEventCellHeight;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    EventHeaderView * headerView = [[EventHeaderView alloc]init];
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


#pragma mark - MemoryManagement 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
