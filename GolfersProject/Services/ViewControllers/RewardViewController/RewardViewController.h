//
//  GrayViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClubHouseSubController.h"

@interface RewardViewController : ClubHouseSubController

@property (strong, nonatomic) IBOutlet UIView *childView;
@property (strong, nonatomic) NSMutableArray *dataObjects;
@property (assign, nonatomic) NSInteger selectedControllerIndex;



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
 @brief It will reload table view of child view controllers.
 
 @discussion This method will track current view and will reload table view of that view using NSInvocation.
 
 */

- (void)reloadChildViewContent:(id)object;

/*!
 @brief remove all refrence. and notifcations.
 
 */

-(void)cycleControllerToIndex:(NSInteger )controllerIndex;


- (void)dealloc;

@end
