//
//  RoundInviteViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/2/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RoundInviteViewController.h"
#import "RoundInviteCell.h"
#import "RoundInviteFriendViewController.h"
#import "AppDelegate.h"

@interface RoundInviteViewController ()

@end

@implementation RoundInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Remove left button
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    // Right bar button
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.inviteArrayImages = [NSArray array];
    self.inviteNames = [NSArray array];
    self.inviteArrayImages = [NSArray arrayWithObjects:@"inApp_invite_unselected", @"fb_invite_unselected", @"sms_invite_unselected", @"email_invite_unselected", @"addGuest", nil];
    self.inviteNames = [NSArray arrayWithObjects:@"IN-APP FRIENDS", @"FACEBOOK", @"SMS", @"EMAIL", @"ADD GUEST", nil];
    [self.inviteTableView reloadData];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.inviteNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"RoundInviteCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoundInviteCell"];
    }
    
    RoundInviteCell *customViewCell = (RoundInviteCell *)customCell;
    customViewCell.lblInviteName.text = [self.inviteNames objectAtIndex:indexPath.row];
    [customViewCell.imgInviteImage setImage:[UIImage imageNamed:self.inviteArrayImages[indexPath.row]]];
    customViewCell.imgInviteImage.contentMode = UIViewContentModeScaleAspectFill;
    [customViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return customViewCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RoundInviteCell * cell = (RoundInviteCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RoundInviteFriendViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundInviteFriendViewController"];
    
    if ([[cell.lblInviteName text] isEqualToString:@"IN-APP FRIENDS"]) {
        controller.currentFriendContactType = FriendContactTypeInAppUser;
    }else
        if ([[cell.lblInviteName text] isEqualToString:@"FACEBOOK"]) {
        controller.currentFriendContactType = FriendContactTypeFacebookEmail;
    }else
        if ([[cell.lblInviteName text] isEqualToString:@"SMS"]) {
        controller.currentFriendContactType = FriendContactTypeAddressbookSMS;
    }else
        if ([[cell.lblInviteName text] isEqualToString:@"EMAIL"]) {
        controller.currentFriendContactType = FriendContactTypeAddressbookEmail;
    }

    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate.appDelegateNavController pushViewController:controller animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
-(void)popSelf{
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.appDelegateNavController popViewControllerAnimated:YES];
}


#pragma mark - MemoryManagement
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
