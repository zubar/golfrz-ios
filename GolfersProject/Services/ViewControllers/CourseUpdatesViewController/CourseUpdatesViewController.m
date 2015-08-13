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

@interface CourseUpdatesViewController ()
@property(strong, nonatomic) NSMutableArray * courseUpdates;

@end

@implementation CourseUpdatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];

    
    // Do any additional setup after loading the view.
     if(!self.courseUpdates) self.courseUpdates = [[NSMutableArray alloc] init];
    
    [self.navigationItem setTitle:@"COURSE UPDATES"];
    
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
    CourseUpdateCell *customViewCell = (CourseUpdateCell *)customCell;
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
        //TODO: image below is not loading.
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
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    
    HMMessagesDisplayViewController * controller = [[HMMessagesDisplayViewController alloc] initWithNibName:@"HMMessagesDisplayViewController" bundle:nil];
    controller.currntActivity = self.courseUpdates[indexPath.row];
    [delegate.appDelegateNavController pushViewController:controller animated:YES];

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
