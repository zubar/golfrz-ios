//
//  RoundInviteSendViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RoundInviteSendViewController.h"
#import "ContactCell.h"

@interface RoundInviteSendViewController ()

@end

@implementation RoundInviteSendViewController

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
    
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactCell"];
    }
    
    ContactCell *customViewCell = (ContactCell *)customCell;
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
