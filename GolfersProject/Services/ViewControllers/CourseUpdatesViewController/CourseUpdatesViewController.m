//
//  CourseUpdatesViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "CourseUpdatesViewController.h"
#import "CourseUpdateCell.h"
#import "CourseUpdateServices.h"
#import "CourseUpdate.h"
#import "GolfrzError.h"
#import "Utilities.h"
#import "Activity.h"

@interface CourseUpdatesViewController ()
@property(strong, nonatomic) NSMutableArray * courseUpdates;

@end

@implementation CourseUpdatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     if(!self.courseUpdates) self.courseUpdates = [[NSMutableArray alloc] init];
    
    [CourseUpdateServices getCourseUpdates:^(bool status, CourseUpdate *update) {
        [self.courseUpdates addObjectsFromArray:[update activities]];
        [self.tblUpdates reloadData];
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.courseUpdates count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"CourseUpdateCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseUpdateCell"];
    }
    
    Activity * courseActivity = self.courseUpdates[indexPath.row];
    
    
    //self.updateType = self.courseUpdates obje
    
    CourseUpdateCell *customViewCell = (CourseUpdateCell *)customCell;
    [customViewCell.lblUpdateText setText:[courseActivity text]];
    
    
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

@end
