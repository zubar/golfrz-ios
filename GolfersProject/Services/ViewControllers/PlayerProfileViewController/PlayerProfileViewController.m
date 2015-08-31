//
//  BlueViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PlayerProfileViewController.h"
#import "ClubHouseContainerVC.h"
#import "ScoreBoardViewController.h"
#import "UserServices.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "CourseServices.h"
#import "Course.h"
#import "PlayerSettingsMainViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+RoundedImage.h"
#import "InviteMainViewController.h"
#import "RoundViewController.h"
#import "AddPlayersViewController.h"
#import "GameSettings.h"
#import "PastScoreCardsViewController.h"
#import "ScoreboardServices.h"
#import "UserServices.h"
#import "Utilities.h"
#import "User+convenience.h"
#import "RewardServices.h"

@interface PlayerProfileViewController (){

}

@end



@implementation PlayerProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];
    
  
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadPreviousScoreCards)];
    [_myScorecardsTapped addGestureRecognizer:tap];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [UserServices getUserInfo:^(bool status, User *mUser) {
        
        [self.lblUserName setText:[mUser contactFullName]];
        if ([mUser.handicap stringValue])
        {
            [self.lblHandicap setText:[mUser.handicap stringValue]];
        }else{
            [self.lblHandicap setText:@"N/A"];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //TODO: get img form FaceBook
        [self.imgUserPic sd_setImageWithURL:[NSURL URLWithString:[mUser imgPath]] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self.imgUserPic setRoundedImage:image];
            }
        }];
    } failure:^(bool status, GolfrzError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get details" delegate:nil cancelButtonTitle:@"CANCEL" otherButtonTitles:nil, nil] show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}

-(void)updateUserRewardPoints
{
    [RewardServices getUserRewardPoints:^(bool status, NSNumber *totalPoints) {
        if(status)
            [self.lblPoints setText:[totalPoints stringValue]];
        else{
            [self.lblPoints setText:@"-"];
        }
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}

- (void) hasUserCheckedIn
{
    [CourseServices getCheckInCount:^(bool status, NSNumber *noOfCheckIns){
        if ([noOfCheckIns boolValue]) {
            [self.checkInView setHidden:NO];
            [self.lblCourseName setText:[[CourseServices currentCourse] courseName]];
        }else{
            [self.checkInView setHidden:YES];
        }
        
    } failure:^(bool status, GolfrzError *error){
        [self.checkInView setHidden:YES];
    }];
}

-(void)roundAlreadyInProgress
{    
    [RoundDataServices getRoundInProgress:^(bool status, NSNumber *roundNo, NSNumber *subCourseId, NSString *teeboxName) {
        if(status){
            [self.btnStartRound setTitle:@"CONTINUE TO ROUND" forState:UIControlStateNormal];
        }
    } finishedRounds:^(bool status) {
        if(!status)
            [self.lblPoints setText:@"0"];
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[self navigationItem] setTitle:@"PLAYER PROFILE"];
    UIButton * imageRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 22, 22)];
    [imageRightButton setBackgroundImage:[UIImage imageNamed:@"invite_icon"] forState:UIControlStateNormal];
    [imageRightButton addTarget:self action:@selector(inviteFriendTap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageRightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-10.0 forBarMetrics:UIBarMetricsDefault];
    
    [self hasUserCheckedIn];
    [self roundAlreadyInProgress];
    [self updateUserRewardPoints];

    GameSettings * settings = [GameSettings sharedSettings];
    if([settings isRoundInProgress]){
        [self.btnStartRound setTitle:@"CONTINUE TO ROUND" forState:UIControlStateNormal
         ]; 
    }else{
        [self.btnStartRound setTitle:@"START NEW ROUND" forState:UIControlStateNormal];
    }
}

- (void)pushNextController
{
        [self.navigationController pushViewController:self.containerVC.rewardViewController animated:YES];
}

- (void)inviteFriendTap
{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    InviteMainViewController * friendsController = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteMainViewController"];
    [delegate.appDelegateNavController pushViewController:friendsController animated:YES];
}

-(void)popToPreviousController
{
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavBarButtonsDelegate

- (IBAction)btnSettingsTapped:(UIButton *)sender
{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    
    PlayerSettingsMainViewController * mainSettingsController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerSettingsMainViewController"];
    [delegate.appDelegateNavController pushViewController:mainSettingsController animated:YES];
    
}
- (IBAction)btnStartRoundTapped:(UIButton *)sender
{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    AddPlayersViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlayersViewController"];
    [delegate.appDelegateNavController pushViewController:controller animated:YES];
    
}

-(void)loadPreviousScoreCards
{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    PastScoreCardsViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PastScoreCardsViewController"];
    [delegate.appDelegateNavController pushViewController:controller animated:YES];
}

@end
