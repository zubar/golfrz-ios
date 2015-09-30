//
//  RewardTutorialDetailVC.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardTutorialContainerVC.h"
#import "SharedManager.h"



typedef NS_ENUM(NSInteger, TutorialPageType){

    TutorialPageTypeWelcome = 0,
    TutorialPageTypeCheckIn,
    TutorialPageTypeInvite,
    TutorialPageTypeSocialShare,
    TutorialPageTypeViewRewards,
    TutorialPageTypePrompt,
    TutorialPageTypeFinish,
};

@interface RewardTutorialDetailVC : UIViewController<SharedManagerDelegate>

@property (weak, nonatomic) RewardTutorialContainerVC * tutorialContainerVC;
@property (weak, nonatomic) RewardViewController * superController;


@property (assign, nonatomic) TutorialPageType pageType;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIImageView *imgRewardBag;


@property (strong, nonatomic) IBOutlet UIButton *rewardTutorialBtn;
@property (strong, nonatomic) IBOutlet UILabel *tutorialDetail;
@property (strong, nonatomic) IBOutlet UIView *socialMediaView;


- (IBAction)viewRewardsBtnTapped:(UIButton *)sender;
- (IBAction)fbShareTapped:(UIButton *)sender;
- (IBAction)twitterShareTapped:(UIButton *)sender;

@end
