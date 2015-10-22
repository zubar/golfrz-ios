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

@interface UILabel (private)
-(void)setNonNullText:(NSString *)text;
@end


@implementation UILabel (private)
-(void)setNonNullText:(NSString *)text{
    
    NSString * labelText = nil;
    if(labelText == (NSString *)[NSNull null]) labelText = @"";
    else labelText = text;
    labelText = [labelText stringByReplacingOccurrencesOfString:@"(null)" withString:@"--"];
    [self setText:labelText];
}

@end

@interface EventCalendarViewController ()

//To mark the dates in calendar
@property (nonatomic, retain) NSMutableArray * currentMonthDates;
@property (nonatomic, retain) NSMutableArray * colors;

@property (nonatomic, retain) NSMutableArray * allKeys;
@property (nonatomic, retain) NSMutableDictionary * events;

@end

@implementation EventCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];

    if(!self.eventslist) self.eventslist = [[NSMutableArray alloc] init];
    
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
    
    if (!self.allKeys) {
        self.allKeys = [[NSMutableArray alloc]init];}
   
    if (!self.colors) {
        self.colors = [[NSMutableArray alloc]init];}
   
    if (!self.events) {
        self.events= [[NSMutableDictionary alloc]init];
    }
}

-(void)reloadCalendarAndEventTable{
    [self.calendar reset];
    [self.calendar markDates:self.currentMonthDates withColors:self.colors];
    [self.eventsTableVeiw reloadData];
}

-(void)updateAllDataStructures{
// future use.
}

#pragma mark - API-Call
-(void)fetchEvents{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CalendarEventServices getEvents:^(bool status, EventList *eventsArray) {
        if (status) {
            
            NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateStart" ascending:YES];
            if([self.eventslist count]>0)[self.eventslist removeAllObjects];
            [self.eventslist addObjectsFromArray:[eventsArray.items sortedArrayUsingDescriptors:@[sortDescriptor]]] ;
            //
            for (CalendarEvent * anEvent in self.eventslist) {
                if (!self.events[anEvent.dateStart]) {
                    [self.events setObject:[[NSMutableArray alloc] initWithObjects:anEvent, nil] forKey:anEvent.dateStart];
                }else{
                    [self.events[anEvent.dateStart] addObject:anEvent];
                }
            }
            [self.allKeys removeAllObjects];
            
            NSSortDescriptor * dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timeIntervalSince1970" ascending:YES];
            [self.allKeys addObjectsFromArray:[[self.events allKeys] sortedArrayUsingDescriptors:@[dateSortDescriptor]]];
            
            
            
            [self reloadCalendarAndEventTable];
            
            if([self.allKeys count] >= 1){
                [self.eventsTableVeiw setHidden:NO];
                [self.lblNoEvents setHidden:YES];
            }else{
                [self.eventsTableVeiw setHidden:YES];
                [self.lblNoEvents setHidden:NO];
            }
            
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
    
    NSInteger currentYear = 0;
     NSDateComponents *timeStamp = [[NSCalendar currentCalendar] components: NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    currentYear = [timeStamp year];
    
    // startDateComponents.
    NSDateComponents *startDateComponents = [NSDateComponents new];
    startDateComponents.calendar = [NSCalendar currentCalendar];
    startDateComponents.year = currentYear;
    startDateComponents.month = month;
    startDateComponents.day   = 1;
    
    NSDate *startDate = [startDateComponents date];
    // Add one day to the previous date. Note that  1 day != 24 h
    NSDateComponents *oneDay = [NSDateComponents new];
    oneDay.day = 30;
    // one day after begin date
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:oneDay
                                                                    toDate:startDate
                                                                   options:0];
    
    [self updateCurrentMonthEventsStartDate:startDate endDate:endDate];
    [self.calendar markDates:self.currentMonthDates withColors:self.colors];
}

-(void)updateCalendarEventTableViewForCalenderHeight:(float)height{
    
    CGRect  appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect finalFrame =  CGRectMake(kEventCalendarMarginLeft, height + 61 , kEventCalendarWidth - 4, appFrame.size.height - height - 41);
    [UIView animateWithDuration:0.35 animations:^{
        [self.eventsTableVeiw setFrame:finalFrame];
    }];
}

/*
 * Method updates the currentMothDates array by filter data from eventslist
 */
-(void)updateCurrentMonthEventsStartDate:(NSDate * )startDate endDate:(NSDate *)endDate{
   
    // Predicate for all dates between startDate and endDate
    if (self.eventslist) {
        NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"dateStart >= %@ AND dateStart < %@",startDate, endDate];
        NSArray * temp = [[self.eventslist filteredArrayUsingPredicate:datePredicate] mutableCopy];
        
        self.currentMonthDates = [temp valueForKeyPath:@"@distinctUnionOfObjects.dateStart"];
        
        for (NSDate * eventDate in self.currentMonthDates) {
                NSLog(@"%@", eventDate);
            [self.colors addObject:[UIColor redColor]];
        }
    }

}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{
    
    for ( NSDate * eventDate in self.allKeys ) {
        if([self daysBetweenDate:date andDate:eventDate] == 0){
            NSIndexPath * indexPathSelectedHeader = [NSIndexPath indexPathForRow:0 inSection:[self.allKeys indexOfObject:eventDate]];
            [self.eventsTableVeiw scrollToRowAtIndexPath:indexPathSelectedHeader atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return;
        }
    }
}
-(NSInteger)daysBetweenDate: (NSDate *)firstDate andDate:(NSDate *)secondDate
{
    NSDate  * firstDateZero = [firstDate dateWithTimeComponentsZeroSet];
    NSDate * secondDateZero = [secondDate dateWithTimeComponentsZeroSet];
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components: NSDayCalendarUnit
                                                      fromDate: firstDateZero
                                                        toDate: secondDateZero
                                                       options: 0];
    
    NSInteger days = [components day];
    return days;
}

#pragma mark - CalendarEventCellDelegate

-(void)tappedDetailedDisclosueForEvent:(CalendarEvent *)event{

    [self performSegueWithIdentifier:@"segueToEventDetailController" sender:event];
}


#pragma mark - UITableViewController DataSource & Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
        NSLog(@"Number of sections:%ld", [self.allKeys count]);
    return [self.allKeys count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"Number of sections for sections:%ld is :%lu ", (long)section, (unsigned long)[self.events[self.allKeys[section]] count]);
    return [self.events[self.allKeys[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *cellIdentifier = @"calendarCellIdentifier";
    
    CalendarEventCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CalendarEventCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    CalendarEvent * eventObject = self.events[self.allKeys[indexPath.section]][indexPath.row];
    NSLog(@"eventObject: %@", eventObject);
    [cell configureViewWithEvent:eventObject];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    cell.delegate = self;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CalendarEvent * eventObject = self.events[self.allKeys[indexPath.section]][indexPath.row];;
    [self performSegueWithIdentifier:@"segueToEventDetailController" sender:eventObject];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CalendarEventCellHeight;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    EventHeaderView * headerView = [[EventHeaderView alloc]init];
    [headerView.imgWeather setHidden:YES];
    [headerView.lblTemperature setHidden:YES];

    NSDate * dateForSection = self.allKeys[section];
    
    
        [Utilities dateComponentsFromNSDate:dateForSection components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString * minutes, NSString * hourAndmin) {
        [headerView.lblDate setText:[[NSString stringWithFormat:@"%@, %@ %@", dayName, monthName, day] uppercaseString]];
        [headerView.lblDate setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        
        [WeatherServices dailyWeather:^(bool status, NSDictionary *weatherData) {
            if (status) {
                // Event is farther then 24 hours don't show temp.
                if([self hoursBetween:dateForSection andEndDate:[NSDate date]] <= 24){
                [headerView.imgWeather sd_setImageWithURL:weatherData[@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    //  <#code#>
                    [headerView.imgWeather setImage:image];
                    [headerView.imgWeather setHidden:NO];
                }];
                [headerView.lblTemperature setNonNullText:[NSString stringWithFormat:@"%@ F", [weatherData[@"temp"] stringValue]]];
                [headerView.lblTemperature setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
                [headerView.lblTemperature setHidden:NO];
                }else{
                    [headerView.lblTemperature setNonNullText:@""];
                    [headerView.lblTemperature setHidden:NO];
                }
            }else{
                [headerView.lblTemperature setHidden:YES];
                [headerView.imgWeather setHidden:YES];
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

-(CGFloat )hoursBetween:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    /*
     --For Testing:
    NSLog(@"EventStart-Date:%@", startDate);
    if(fabs([endDate timeIntervalSinceDate:startDate] / 3600.0) < 24){
        NSLog(@"should display Event Weather");
    }
     */

    return fabs([endDate timeIntervalSinceDate:startDate] / 3600.0);
}
@end
