//
//  RewardTutorialDetailVC.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RewardTutorialDetailVC.h"
#import "SharedManager.h"
#import "CourseServices.h"
#import "Utilities.h"
#import "GolfrzError.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "InviteMainViewController.h"
#import <Social/Social.h>
#import "Constants.h"

@interface RewardTutorialDetailVC (){
    bool isFbTapped;
    SLComposeViewController *socialMediaController;
}




@end

@implementation RewardTutorialDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isFbTapped = false;
    
    //Or whatever number of viewcontrollers you have
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view setHidden:YES];

    
    UISwipeGestureRecognizer *  rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadPreviousController)];
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *  leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadNextController)];
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:leftRecognizer];
    
    [self.pageControl setNumberOfPages:kTutorialPagesCount +1];
    [self.pageControl setCurrentPage:self.pageType];
    [self populateDataForPageType:self.pageType];
    [self configureViewForType:self.pageType];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadPreviousController{
    if (self.pageType -1 >= 0) {
        [self.tutorialContainerVC cycleControllerToIndex:self.pageType - 1];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    isFbTapped = false;
    [self.view setHidden:NO];
}

-(void)loadNextController{
    if(self.pageType + 1 <= kTutorialPagesCount){
        [self.tutorialContainerVC cycleControllerToIndex:self.pageType + 1];
    }
}


-(void)configureViewForType:(TutorialPageType )pageType{
    
    if((pageType == TutorialPageTypeCheckIn) ||
       (pageType == TutorialPageTypeInvite) ||
       (pageType == TutorialPageTypeViewRewards) ||
       (pageType == TutorialPageTypeFinish))
    {
        [self.rewardTutorialBtn setHidden:NO];
        [self.tutorialDetail setHidden:NO];
        [self.imgRewardBag setHidden:YES];
        [self.socialMediaView setHidden:YES];
    }else
        if(pageType ==  TutorialPageTypePrompt){
            [self.rewardTutorialBtn setHidden:YES];
            [self.tutorialDetail setHidden:NO];
            [self.imgRewardBag setHidden:YES];
            [self.socialMediaView setHidden:YES];
        }else
            if(pageType == TutorialPageTypeWelcome){
                [self.rewardTutorialBtn setHidden:YES];
                [self.tutorialDetail setHidden:NO];
                [self.imgRewardBag setHidden:NO];
                [self.socialMediaView setHidden:YES];

            }else
                if(pageType == TutorialPageTypeSocialShare){
                    [self.rewardTutorialBtn setHidden:YES];
                    [self.tutorialDetail setHidden:NO];

                    [self.socialMediaView setHidden:NO];
                    [self.imgRewardBag setHidden:YES];

                }
}

-(void)populateDataForPageType:(TutorialPageType )pageType{
    
    NSString * detail = nil;
    switch (pageType) {
        case TutorialPageTypeWelcome:
            detail = RewardTutorialHeading;
            break;
        case TutorialPageTypeCheckIn:
            detail = CheckInReward;
            [self.rewardTutorialBtn setTitle:@"CHECK IN NOW" forState:UIControlStateNormal];
            break;
        case TutorialPageTypeInvite:
            detail = InviteFriendsReward;
            [self.rewardTutorialBtn setTitle:@"INVITE NOW" forState:UIControlStateNormal];
            break;
        case TutorialPageTypeSocialShare:
            detail = SocialMediaReward;
            break;
        case TutorialPageTypePrompt:
            detail = ScoreCardReward;
            break;
        case TutorialPageTypeViewRewards:
            detail = RoundsReward;
            [self.rewardTutorialBtn setTitle:@"VIEW REWARDS" forState:UIControlStateNormal];
            break;
        case TutorialPageTypeFinish:
            detail = FinalRewardHeading;
            [self.rewardTutorialBtn setTitle:@"VIEW REWARDS" forState:UIControlStateNormal];
            break;
        default:
            detail = @"";
            break;
    }
    [self.tutorialDetail setText:detail];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)viewRewardsBtnTapped:(UIButton *)sender {
    
    switch (self.pageType) {
        case TutorialPageTypeFinish:
            [self.superController cycleControllerToIndex:0];
            break;
        case TutorialPageTypeViewRewards:
            [self.superController cycleControllerToIndex:0];
            break;
        case TutorialPageTypeCheckIn:
            [self checkInUser];
            break;
        case TutorialPageTypeInvite:
            [self InvideFriends];
            break;
        default:
            break;
    }
}

- (IBAction)fbShareTapped:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isFbTapped = true;
    [self socialMediaBtnTapped];
    }

- (IBAction)twitterShareTapped:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isFbTapped = false;
    [self socialMediaBtnTapped];
}

-(void)InvideFriends{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    InviteMainViewController * friendsController = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteMainViewController"];
    [delegate.appDelegateNavController pushViewController:friendsController animated:YES];

}

-(void)checkInUser{

    if ([CourseServices currentCourse]) {
        [self checkInToCurrentCourse];
    }else{
        [self loadCourseDetailsCompletionBlock:^(Course *currentCourse) {
            [self checkInToCurrentCourse];
        }];
    }
}

-(void)checkInToCurrentCourse{
    
    SharedManager * manager = [SharedManager sharedInstance];
    [manager triggerLocationServices];
    manager.delegate = self;
}


-(void)loadCourseDetailsCompletionBlock:(void (^)(Course *currentCourse))completionBlock{
    
    [CourseServices courseDetailInfo:^(bool status, Course *currentCourse) {
        if (status) {
            //TODO: any business logic on it to apply.
            if (status) {
                completionBlock(currentCourse);
            }
        }
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}

-(void)IsUserInCourseWithRequiredAccuracy:(BOOL)yesNo{
    
    if (yesNo) {
        [CourseServices checkInToCurrentCourse:^(bool status, id responseObject) {
            if (status) {
                [[[UIAlertView alloc]initWithTitle:@"Success" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                [self populateDataForPageType:self.pageType];
            }
        } failure:^(bool status, NSError * error) {
            if (status) {
                [[[UIAlertView alloc]initWithTitle:@"Try Again" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }];
    }else{
        NSString * message = [NSString stringWithFormat:@"You are not %d meter inside the course perimeter.",kAccuracyGPS];
        [[[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
    
}

-(void)socialMediaBtnTapped{
    
    if (isFbTapped){
        socialMediaController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    }
    else{
        socialMediaController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    }
    
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [socialMediaController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }};
        
        //[socialMediaController addImage:[UIImage imageNamed:@"1.jpg"]]; //for adding any image to share
        [socialMediaController setInitialText:@"Type your message that you want to share"];
        //[socialMediaController addURL:[NSURL URLWithString:@"https://www.google.com/"]]; //for adding any URL to be shared
        [socialMediaController setCompletionHandler:completionHandler];
        [self presentViewController:socialMediaController animated:YES completion:nil];

}
@end
