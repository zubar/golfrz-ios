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
#import "SharedManager.h"
#import "UIImageView+RoundedImage.h"
#import "Utilities.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "HMMessagesDisplayViewController.h"
#import "MBProgressHUD.h"
#import "UserServices.h"
#import "User.h"
#import "NSDate+Helper.h"
#import "BBBadgeBarButtonItem.h"

@interface CourseUpdatesViewController ()
@property(strong, nonatomic) NSMutableArray * courseUpdates;

@end

@implementation CourseUpdatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];
    // Do any additional setup after loading the view.
     if(!self.courseUpdates) self.courseUpdates = [[NSMutableArray alloc] init];
    [self.navigationItem setTitle:@"COURSE UPDATES"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CourseUpdateServices getCourseUpdates:^(bool status, CourseUpdate *update) {
        if([self.courseUpdates count] >0) [self.courseUpdates removeAllObjects];
        
        [self.courseUpdates addObjectsFromArray:[update activities]];
        [self.tblUpdates reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    
    [UserServices getUserInfo:^(bool status, User *mUser) {
        [UserServices setCurrentUSerName:[mUser firstName]];
    } failure:^(bool status, GolfrzError *error) {
        [UserServices setCurrentUSerName:@"ME"];
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
    CourseUpdateCell *customViewCell = (CourseUpdateCell *)customCell;
    customViewCell.selectionStyle = UITableViewCellSelectionStyleGray;
    [customViewCell.lblUpdateText setText:[courseActivity text]];
    
    
    [customViewCell.imgCourseLogo sd_setImageWithURL:[NSURL URLWithString:[SharedManager sharedInstance].logoImagePath] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [customViewCell.imgCourseLogo setRoundedImage:image];
        }
    }];
 

    if (![courseActivity.isCommentable boolValue]){
        [customViewCell.commentsView setHidden:YES];
        [customViewCell.kudosView setHidden:YES];
        customViewCell.lblUpdateTestTrailingConstraints.constant = -40;
        [customViewCell.singleImageView setHidden:NO];
        [customViewCell.detailCommentsView setHidden:YES];
        [customViewCell.imgUpdateImage sd_setImageWithURL:[NSURL URLWithString:[courseActivity imgPath]] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [customViewCell.imgUpdateImage setRoundedImage:image];
        }];
    }else{
        [customViewCell.commentsView setHidden:NO];
        [customViewCell.kudosView setHidden:NO];
        customViewCell.lblUpdateTestTrailingConstraints.constant = 5;
        [customViewCell.singleImageView setHidden:YES];
        [customViewCell.detailCommentsView setHidden:NO];
        NSString *commentsCount = [NSString stringWithFormat:@"%@ %@", [courseActivity.commentsCount stringValue], @"comments"];
        customViewCell.lblCommentsCount.text = commentsCount;
        customViewCell.kudosCount.text = [courseActivity.likesCount stringValue];
        
        [Utilities dateComponentsFromNSDate:[courseActivity createdAt] components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute) {
            customViewCell.lblDay.text = dayName;
            customViewCell.lblTime.text = time;
        }];
        
        if ([courseActivity.hasUserCommented boolValue]) {
            [customViewCell.btnAddComments setBackgroundImage:[UIImage imageNamed:@"comments_liked_btn"] forState:UIControlStateNormal];
        }else{
            [customViewCell.btnAddComments setBackgroundImage:[UIImage imageNamed:@"comments_btn"] forState:UIControlStateNormal];
        }
        if ([courseActivity.hasUserLiked boolValue]) {
            [customViewCell.btnKudos setBackgroundImage:[UIImage imageNamed:@"kudos_liked"] forState:UIControlStateNormal];
        }else{
            [customViewCell.btnKudos setBackgroundImage:[UIImage imageNamed:@"kudos"] forState:UIControlStateNormal];
        }
    }
    return customViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Activity * courseActivity = self.courseUpdates[indexPath.row];
    [CourseUpdateServices markNotificationReadWithUserNotificationId:[courseActivity userNotificationId] success:^(bool status, id response) {
        //We are not doing anything, just update on server.
    }];
    
    if ([courseActivity.isCommentable boolValue]){
        AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    
        HMMessagesDisplayViewController * controller = [[HMMessagesDisplayViewController alloc] initWithNibName:@"HMMessagesDisplayViewController" bundle:nil];
        controller.currntActivity = courseActivity;
        [delegate.appDelegateNavController pushViewController:controller animated:YES];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:nil message:@"You cannot comment or give kudos to this post" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:nil] show];
    }

}

@end
