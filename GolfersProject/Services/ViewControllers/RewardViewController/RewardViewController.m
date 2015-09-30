//
//  GrayViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RewardViewController.h"
#import "ClubHouseContainerVC.h"
#import "RewardListViewController.h"
#import "RewardTutorialContainerVC.h"
#import "RewardServices.h"
#import "UserServices.h"
#import "User.h"
#import "User+convenience.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+RoundedImage.h"
#import "Utilities.h"
#import "GolfrzError.h"
#import "SharedManager.h"
#import "CourseServices.h"
#import "Course.h"
#import "RewardServices.h"
#import "RewardDescriptionViewController.h"
#import "AppDelegate.h"
#import "InviteMainViewController.h"
#import "Constants.h"

@interface RewardViewController (){
        RewardListViewController  *_rewardListVC;
        RewardTutorialContainerVC *_rewardTutorialContainerVC;
        RewardDescriptionViewController * _rewardDescriptionViewController;
    
        UIViewController __weak *_currentChildController;
}
/*! @brief Array of view controllers to switch between */
@property (nonatomic, copy) NSArray *allViewControllers;
@end

@implementation RewardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateRewardPoints) name:kUpdateRewardPoints object:nil];
    
    /*! @brief Array of view controllers to switch between */
    self.selectedControllerIndex = 0;
    [self.checkedInContainerView setHidden:YES];
    [self populateUserPointsView];
    
    //
    _rewardDescriptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardDescriptionViewController"];
    _rewardDescriptionViewController.rewardViewController = self;
    
    // let's create our two controllers
    _rewardListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardListViewController"];
    _rewardListVC.rewardViewController = self;
    _rewardListVC.rewardDescriptionViewController = _rewardDescriptionViewController;
    
    _rewardTutorialContainerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardTutorialContainerVC"];
    _rewardTutorialContainerVC.rewardViewController = self;
    
   
    
    // Add A and B view controllers to the array
    self.allViewControllers = [[NSArray alloc] initWithObjects:_rewardListVC, _rewardTutorialContainerVC, _rewardDescriptionViewController, nil];
    
    [self cycleFromViewController:_currentChildController toViewController:[self.allViewControllers objectAtIndex:self.selectedControllerIndex]];
    
}

-(void)cycleControllerToIndex:(NSInteger )controllerIndex{
    self.selectedControllerIndex = controllerIndex;
    [self cycleFromViewController:_currentChildController toViewController:[self.allViewControllers objectAtIndex:self.selectedControllerIndex]];
}

- (void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC {
    
    // Do nothing if we are attempting to swap to the same view controller
    if (newVC == oldVC) return;
    
    // Check the newVC is non-nil otherwise expect a crash: NSInvalidArgumentException
    if (newVC) {
        
        // Set the new view controller frame (in this case to be the size of the available screen bounds)
        // Calulate any other frame animations here (e.g. for the oldVC)
        newVC.view.frame = CGRectMake(0.0,
                                      0.0,
                                      self.childView.frame.size.width,
                                      self.childView.frame.size.height);
        
        // Check the oldVC is non-nil otherwise expect a crash: NSInvalidArgumentException
        if (oldVC) {
            
            // Start both the view controller transitions
            [oldVC willMoveToParentViewController:nil];
            [self addChildViewController:newVC];
            
            // Swap the view controllers
            // No frame animations in this code but these would go in the animations block
            [self transitionFromViewController:oldVC
                              toViewController:newVC
                                      duration:0.25
                                       options:UIViewAnimationOptionLayoutSubviews
                                    animations:^{}
                                    completion:^(BOOL finished) {
                                        // Finish both the view controller transitions
                                        [oldVC removeFromParentViewController];
                                        [newVC didMoveToParentViewController:self];
                                        // Store a reference to the current controller
                                        _currentChildController = newVC;
                                        [_currentChildController.view layoutIfNeeded];
                                    }];
            
        } else {
            
            [self addChildToThisContainerViewController:newVC];
            // Otherwise we are adding a view controller for the first time
            // Start the view controller transition
            [self addChildViewController:newVC];
            
            // End the view controller transition
            [newVC didMoveToParentViewController:self];
            
            
            // Add the new view controller view to the ciew hierarchy
            [self.childView addSubview:newVC.view];
            
            // Store a reference to the current controller
            _currentChildController = newVC;
        }
    }
}


- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[self navigationItem] setTitle:@"REWARDS"];
    UIButton * imageRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 22, 22)];
    [imageRightButton setBackgroundImage:[UIImage imageNamed:@"invite_icon"] forState:UIControlStateNormal];
    [imageRightButton addTarget:self action:@selector(inviteFriendTap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageRightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - Private Methods
/**********
 ********** add childs. **********
 **********/

- (void)addChildToThisContainerViewController:(UIViewController *)childController
{
    [self addChildViewController:childController];
    [childController didMoveToParentViewController:self];
    childController.view.frame = CGRectMake(0.0,
                                            0.0,
                                            self.childView.frame.size.width,
                                            self.childView.frame.size.height);
}

#pragma mark - IBAction

-(void)popToPreviousController{
        [self.navigationController popViewControllerAnimated:YES];
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // let's release our child controllers
    _rewardListVC = nil;
    _rewardTutorialContainerVC = nil;
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateUserPointsView{
    
    /*
     Loading user personal info.
     */
    [UserServices getUserInfo:^(bool status, User *mUser) {
        if(status){
            [self.lblUserName setText:[mUser contactFullName]];
            [self.imgUserProfile sd_setImageWithURL:[NSURL URLWithString:[mUser imgPath]] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    [self.imgUserProfile setRoundedImage:image];
                }
            }];
        }
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
    
    // update user checkIn count.
    [self updateCheckInCount];
    
    // get total reward points of user.
    [self updateRewardPoints];
}

- (void)updateCheckInCount
{
    // Get total count of checkings of user.
    [CourseServices getCheckInCount:^(bool status, NSNumber *countOfCheckin) {
        if([countOfCheckin integerValue] > 0){
            [self.checkedInContainerView setHidden:NO];
            [self.lblCountCheckIns setText:[countOfCheckin stringValue]];
            [self.lblCheckInCourseName setText:[[CourseServices currentCourse] courseName]];
        }else{
            [self.lblCountCheckIns setText:[countOfCheckin stringValue]];
        }
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}

-(void)updateRewardPoints
{
    [RewardServices getUserRewardPoints:^(bool status, NSNumber *totalPoints) {
        if(status) {
            [self.lblTotlPoints setHidden:NO];
            [self.lblPromptPoints setHidden:NO];
            [self.lblTotlPoints setText:[totalPoints stringValue]];}
    } failure:^(bool status, GolfrzError *error) {
        [self.lblTotlPoints setHidden:YES];
        [self.lblPromptPoints setHidden:YES];
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];
}

- (void)inviteFriendTap{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    InviteMainViewController * friendsController = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteMainViewController"];
    [delegate.appDelegateNavController pushViewController:friendsController animated:YES];
    
}
@end
