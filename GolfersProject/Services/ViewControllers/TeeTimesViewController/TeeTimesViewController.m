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

@interface TeeTimesViewController ()

@end

@implementation TeeTimesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GameSettings * settings =[GameSettings sharedSettings];
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
}
@end
