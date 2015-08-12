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

@interface RewardTutorialDetailVC ()

@end

@implementation RewardTutorialDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
            detail = @"Here you can see how to earn points as well as claim your rewards!";
            break;
        case TutorialPageTypeCheckIn:
            detail = @"Earn 5 points every time you check in to the course.";
            [self.rewardTutorialBtn setTitle:@"CHECK IN NOW" forState:UIControlStateNormal];
            break;
        case TutorialPageTypeInvite:
            detail = @"Earn 25 points for each friend you invite to the app.";
            [self.rewardTutorialBtn setTitle:@"INVITE NOW" forState:UIControlStateNormal];
            break;
        case TutorialPageTypeSocialShare:
            detail = @"Earn 5 more points for each social network you post on.";
            break;
        case TutorialPageTypePrompt:
            detail = @"Earn 10 points for every Scorecard you post to your Player Profile.";
            break;
        case TutorialPageTypeViewRewards:
            detail = @"Finally, earn points when you finish 5, 10 or 25 consecutive rounds.";
            [self.rewardTutorialBtn setTitle:@"VIEW REWARDS" forState:UIControlStateNormal];
            break;
        case TutorialPageTypeFinish:
            detail = @"Then, it's time to collect your rewards!";
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
        default:
            break;
    }
}

- (IBAction)fbShareTapped:(UIButton *)sender {
    
    
}

- (IBAction)twitterShareTapped:(UIButton *)sender {
    
    
}

-(void)InvideFriends{

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
                [[[UIAlertView alloc]initWithTitle:@"Success" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                [self populateDataForPageType:self.pageType];
            }
        } failure:^(bool status, NSError * error) {
            if (status) {
                [[[UIAlertView alloc]initWithTitle:@"Try Again" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
        }];
    }else{
        NSString * message = [NSString stringWithFormat:@"You are not %d meter inside the course perimeter.",kAccuracyGPS];
        [[[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    
    
}
@end
