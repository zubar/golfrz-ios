//
//  TeeTimesViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/8/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "TeeTimesViewController.h"
#import "TeeTimeBookingCell.h"

@interface TeeTimesViewController ()

@end

@implementation TeeTimesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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
