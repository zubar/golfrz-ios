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

@interface PlayerProfileViewController (){

}

@end



@implementation PlayerProfileViewController

- (void)viewDidLoad {
    
    
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
        [self.imgUserPic sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self.imgUserPic setRoundedImage:image];
            }
        }];
        
        
    } failure:^(bool status, GolfrzError *error) {
        //TODO: add in a separate file all the alert messages.
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get details" delegate:nil cancelButtonTitle:@"CANCEL" otherButtonTitles:nil, nil] show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}

- (void) hasUserCheckedIn{
    [CourseServices getCheckInCount:^(bool status, NSNumber *noOfCheckIns){
        if ([noOfCheckIns boolValue]) {
            [self.checkInView setHidden:NO];
            //TODO: sometimes course name is not available
            [self.lblCourseName setText:[[CourseServices currentCourse] courseName]];
        }else{
            [self.checkInView setHidden:YES];
        }
        
    } failure:^(bool status, GolfrzError *error){
        [self.checkInView setHidden:YES];
    }];
}

-(void)roundAlreadyInProgress{
    
    [RoundDataServices getRoundInProgress:^(bool status, NSNumber *roundNo, NSNumber *subCourseId, NSString *teeboxName) {
        if(status)
        [ScoreboardServices getTotalScoreForAllPlayersForRoundId:roundNo
                                                         success:^(bool status, NSDictionary *playerTotalScore)
         {
             NSString * userId = [NSString stringWithFormat:@"%@",[UserServices currentUserId]];
             if([playerTotalScore objectForKey:userId] != nil){
                NSNumber * score =  [playerTotalScore objectForKey:userId];
                 [self.lblPoints setText:[score stringValue]];
                 [self.btnStartRound setTitle:@"CONTINUE TO ROUND" forState:UIControlStateNormal];
             }else{
                 [self.lblPoints setText:@""];
             }
        } failure:^(bool status, GolfrzError *error) {
            [Utilities displayErrorAlertWithMessage:[error errorMessage]];
        }];
        
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

    GameSettings * settings = [GameSettings sharedSettings];
    if([settings isRoundInProgress]){
        [self.btnStartRound setTitle:@"CONTINUE TO ROUND" forState:UIControlStateNormal
         ]; 
    }else{
        [self.btnStartRound setTitle:@"START NEW ROUND" forState:UIControlStateNormal];
    }

}

- (void)pushNextController{
        [self.navigationController pushViewController:self.containerVC.rewardViewController animated:YES];
}

- (void)inviteFriendTap{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    InviteMainViewController * friendsController = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteMainViewController"];
    [delegate.appDelegateNavController pushViewController:friendsController animated:YES];

}

-(void)popToPreviousController{
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavBarButtonsDelegate


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSettingsTapped:(UIButton *)sender {
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    
    PlayerSettingsMainViewController * mainSettingsController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerSettingsMainViewController"];
    [delegate.appDelegateNavController pushViewController:mainSettingsController animated:YES];
    
}
- (IBAction)btnStartRoundTapped:(UIButton *)sender {
    
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
