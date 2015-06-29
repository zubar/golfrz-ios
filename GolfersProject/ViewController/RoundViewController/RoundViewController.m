//
//  RoundViewController.m
//  GolfersProject
//
//  Created by Zubair on 6/26/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RoundViewController.h"
#import "PlayerScoreCell.h"

@interface RoundViewController ()

@end

@implementation RoundViewController

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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"PlayerScoreCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlayerScoreCell"];
    }
    
    PlayerScoreCell *customViewCell = (PlayerScoreCell *)customCell;
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

- (IBAction)btnPenaltyTapped:(UIButton *)sender {
}

- (IBAction)btnShotTapped:(UIButton *)sender {
}

- (IBAction)btnPuttTapped:(UIButton *)sender {
}

- (IBAction)btnFlyoverTapped:(UIButton *)sender {
}
- (IBAction)btnNextHoleTapped:(UIButton *)sender {
}

- (IBAction)btnPreviousHoleTapped:(UIButton *)sender {
}
@end
