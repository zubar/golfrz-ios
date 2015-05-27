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

@interface EventCalendarViewController ()

@end

@implementation EventCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.calendar = [[VRGCalendarView alloc] init];
    [self.calendar setFrame:CGRectMake(0.0f, 60.0f, 320.0f, 320.0f)];
   // [self.calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CST"]];
    [self.calendar setBackgroundColor:[UIColor clearColor]];
    
    [self.calendar setDelegate:self];
    [self.view addSubview:self.calendar];
    
    [self fetchEvents];
    
    [self.eventsTableVeiw setBackgroundColor:[UIColor clearColor]];
    [self.eventsTableVeiw setBackgroundView:nil];
    
}


-(void)fetchEvents{
    [CalendarEventServices getEvents:^(bool status, EventList *eventsArray) {
        if (status) {
            self.eventslist = eventsArray;
            [self updateEventDates];
            [self reloadCalenderVeiw];
            [self.eventsTableVeiw reloadData];
        }
    } failure:^(bool status, NSError *error) {
        if (!status) {
            NSLog(@"Error");
        }
    }];
}

-(void)updateEventDates{
    
    if (!self.eventDates) {
        self.eventDates = [[NSMutableArray alloc]init];
    }
    if (!self.colors) {
        self.colors = [[NSMutableArray alloc]init];
    }
    
    [self.eventDates removeAllObjects];
    [self.colors removeAllObjects];
    
    for (CalendarEvent * calEvent in self.eventslist.items) {
        NSLog(@"%@", calEvent.dateStart);
        [self.eventDates addObject:calEvent.dateStart];
        [self.colors addObject:[UIColor redColor]];
    }
}

-(void)reloadCalenderVeiw{
  //  NSArray *color = [NSArray arrayWithObjects:[UIColor redColor],nil];
    [self.calendar markDates:self.eventDates withColors:self.colors];
}

#pragma mark - VRGCalendarView Delegate

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated{
    [self.calendar markDates:self.eventDates withColors:self.colors];
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{


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
    return [self.eventslist.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *cellIdentifier = @"calendarCellIdentifier";
    
    CalendarEventCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CalendarEventCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    CalendarEvent * eventObject = [self.eventslist.items objectAtIndex:indexPath.row];
   // cell.lbleventName.text = eventObject.name;
    [cell configureViewWithEvent:eventObject];
    
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CalendarEventCellHeight;
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
