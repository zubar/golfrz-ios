//
//  AddPlayersInvitedController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/2/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "AddPlayersInvitedController.h"
#import "RoundPlayerCell.h"


@interface AddPlayersInvitedController ()

@end

@implementation AddPlayersInvitedController

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
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"RoundPlayerCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoundPlayerCell"];
    }
    
    RoundPlayerCell *customViewCell = (RoundPlayerCell *)customCell;
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

- (IBAction)btnStartRoundTapped:(UIButton *)sender {
}
@end
