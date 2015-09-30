//
//  GrayViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClubHouseSubController.h"
#import "RewardTutorialDetailVC.h"

@interface RewardViewController : ClubHouseSubController

@property (strong, nonatomic) IBOutlet UIView *childView;
@property (assign, nonatomic) NSInteger selectedControllerIndex;

@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblTotlPoints;
@property (weak, nonatomic) IBOutlet UILabel *lblCountCheckIns;
@property (weak, nonatomic) IBOutlet UIView *checkedInContainerView;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckInCourseName;
@property (weak, nonatomic) IBOutlet UILabel *lblPromptPoints;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;

-(void)updateRewardPoints;
/*!
 @brief It cycles two view controllers.
 
 @discussion This method swap two view controllers. It will do nothing if we are attempting to swap to the same view controller
 
 To use it, simply call @c[self cycleFromViewController:_currentChildController toViewController:[self.allViewControllers objectAtIndex:self.segmentedControl.selectedSegmentIndex]];
 
 @param oldVC Previously selected view.
 @param newVC New selected view.
 
 */

- (void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC;

/*!
 @brief It will add a child controller on top.
 
 @param childController selected view controller.
 
 */

- (void)addChildToThisContainerViewController:(UIViewController *)childController;
/*!
 @brief remove all refrence. and notifcations.
 
 */

-(void)cycleControllerToIndex:(NSInteger )controllerIndex;


- (void)dealloc;

@end
