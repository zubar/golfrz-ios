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

    [self updateCalendarEventTableViewForCalenderHeight:kEventCalendarHeight];
    
    self.calendar = [[VRGCalendarView alloc] init];
    [self.calendar setFrame:CGRectMake(kEventCalendarMarginLeft, kEventCalendarMarginTop, kEventCalendarWidth, kEventCalendarHeight)];
    [self.calendar setBackgroundColor:[UIColor clearColor]];
    
    [self.calendar setDelegate:self];
    [self.view addSubview:self.calendar];
    
    [self.eventsTableVeiw setBackgroundColor:[UIColor clearColor]];
    [self.eventsTableVeiw setBackgroundView:nil];
    
    
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
    
    CGRect  appFrameSize = [[UIScreen mainScreen] applicationFrame];
    
    [self.eventsTableVeiw setFrame:CGRectMake(kEventCalendarMarginLeft, kEventCalendarMarginTop + height, kEventCalendarWidth, appFrameSize.size.height - kEventCalendarMarginTop - height)];

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
    
    NSDate *today = [todayComponents date];
    
    if (self.eventslist) {
        NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"dateStart == %@", today];
        self.todayEvents = [[self.eventslist.items filteredArrayUsingPredicate:datePredicate] mutableCopy];
        [self.eventsTableVeiw reloadData];
    }
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
   // cell.lbleventName.text = eventObject.name;
    [cell configureViewWithEvent:eventObject];
    
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CalendarEventCellHeight;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [[UIView alloc]init];
    [header setBackgroundColor:[UIColor yellowColor]];
    return header;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * header = [[UIView alloc]init];
    [header setBackgroundColor:[UIColor greenColor]];
    return header;
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
