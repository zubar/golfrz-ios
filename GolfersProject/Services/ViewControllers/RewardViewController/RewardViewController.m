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

@interface RewardViewController (){
        RewardListViewController  *_rewardListVC;
        RewardTutorialContainerVC *_rewardTutorialContainerVC;
        UIViewController __weak *_currentChildController;
}
/*! @brief Array of view controllers to switch between */
@property (nonatomic, copy) NSArray *allViewControllers;
@end

@implementation RewardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*! @brief Array of view controllers to switch between */
    self.selectedControllerIndex = 0;
    
    // let's create our two controllers
    _rewardListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardListViewController"];
    _rewardTutorialContainerVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([RewardTutorialContainerVC class])];
    //    _letPropertyVC.dataSource = _dataSource;
    // Add A and B view controllers to the array
    self.allViewControllers = [[NSArray alloc] initWithObjects:_rewardListVC, _rewardTutorialContainerVC, nil];
    
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
                                      duration:1.25
                                       options:UIViewAnimationOptionLayoutSubviews
                                    animations:^{}
                                    completion:^(BOOL finished) {
                                        // Finish both the view controller transitions
                                        [oldVC removeFromParentViewController];
                                        [newVC didMoveToParentViewController:self];
                                        // Store a reference to the current controller
                                        _currentChildController = newVC;
                                        [self reloadChildViewContent:self.dataObjects];
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
}

#pragma mark -
#pragma mark - Private Methods

- (NSMutableArray *)dataObjects {
    if (_dataObjects == nil) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        _dataObjects = array;
    }
    return _dataObjects;
}

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

#pragma Service Call

/**********
 ********** Call ToLet residences Service **********
 **********/

- (void)callToLetResidenceService  {
   
}

//- (void)reloadChildViewContent:(id)object  {
//    
//    NSInvocation *invocation = [NSInvocation jr_invocationWithTarget:_currentChildController block:^(id myObject)   {
//        [myObject reloadChildViewContent:object];
//    }];
//    [invocation invoke];
//}


#pragma mark -
#pragma mark - IBAction

/**********
 ********** Add new property View **********
 **********/

//- (IBAction)addNewPropertyBtn:(UIButton *)sender    {
//    
//    AddNewPropertyVC *addNewPropertyVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AddNewPropertyVC class])];
//    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:addNewPropertyVC];
//    [self presentViewController:navigationController animated:YES completion:^{
//        
//    }];
//}

/**********
 ********** segmented Control Value Changed **********
 **********/
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
    
    NSUInteger index = sender.selectedSegmentIndex;
    
    if (UISegmentedControlNoSegment != index) {
        UIViewController *incomingViewController = [self.allViewControllers objectAtIndex:index];
        [self cycleFromViewController:_currentChildController toViewController:incomingViewController];
    }
    
}

-(void)popToPreviousController{
        [self.navigationController popViewControllerAnimated:YES];
}


-(void)dealloc {
    // let's release our child controllers
    _rewardListVC = nil;
    _rewardTutorialContainerVC = nil;
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
