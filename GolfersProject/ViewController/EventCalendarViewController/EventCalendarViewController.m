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

@interface EventCalendarViewController ()

@end

@implementation EventCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.calendar = [[VRGCalendarView alloc] init];
    [self.calendar setFrame:CGRectMake(0.0f, 60.0f, 320.0f, 320.0f)];
   // [self.calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CST"]];
    
    [self.calendar setDelegate:self];
    [self.view addSubview:self.calendar];
    
    [self fetchEvents];
    
    
}


-(void)fetchEvents{
    [CalendarEventServices getEvents:^(bool status, EventList *eventsArray) {
        if (status) {
            self.eventslist = eventsArray;
            [self updateEventDates];
            [self reloadCalenderVeiw];
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
//2015-05-27 19:00:00 +0000


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"leaveRequestCellIdentifier";
    
    TACustomLeaveViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"TACustomLeaveViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    DTOLeave * leaveObject = (DTOLeave *)[self.leavesArray objectAtIndex:indexPath.row];
    
    
    [cell setDurationViewBoundary];
    
    NSArray * startDateComponents = [leaveObject.startDate componentsSeparatedByString:@"-"];
    NSArray * endDateComponents = [leaveObject.endDate componentsSeparatedByString:@"-"];
    
    int leaveCount = [[endDateComponents objectAtIndex:2] intValue] - [[startDateComponents objectAtIndex:2] intValue] + 1;
    
    cell.nameLabel.text = leaveObject.studentName;
    cell.monthLabel.text = [monthsNameArray objectAtIndex:[[startDateComponents objectAtIndex:1] intValue] - 1];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@ Leave , %dDays", leaveObject.type, leaveCount];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@-%@", [startDateComponents objectAtIndex:2], [endDateComponents objectAtIndex:2]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MemoryManagement 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
