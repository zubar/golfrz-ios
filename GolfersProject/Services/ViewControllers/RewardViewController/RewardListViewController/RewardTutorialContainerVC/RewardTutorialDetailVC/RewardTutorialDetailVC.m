//
//  RewardTutorialDetailVC.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RewardTutorialDetailVC.h"

@interface RewardTutorialDetailVC ()

@end

@implementation RewardTutorialDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGPoint origin = CGPointMake( self.view.frame.size.width/2, self.view.frame.size.height/1.5 );
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(origin.x, origin.y,
                                                                       0, 0)];
    
    [self.pageControl setTag:90];
    //Or whatever number of viewcontrollers you have
    [self.pageControl setNumberOfPages:3];
    
    UISwipeGestureRecognizer *  rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadPreviousController)];
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *  leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadNextController)];
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:leftRecognizer];
    
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

-(void)loadNextController{
    
    if(self.pageType + 1 <= 6){
        [self.tutorialContainerVC cycleControllerToIndex:self.pageType + 1];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor clearColor]];
   
    [self populateDataForPageType:self.pageType];
    [self configureViewForType:self.pageType];
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

- (IBAction)rewardTutorialBtnTapped:(UIButton *)sender {
}
- (IBAction)fbShareTapped:(UIButton *)sender {
}

- (IBAction)twitterShareTapped:(UIButton *)sender {
}
@end
