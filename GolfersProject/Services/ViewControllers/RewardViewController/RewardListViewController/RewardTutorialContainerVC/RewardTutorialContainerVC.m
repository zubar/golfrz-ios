//
//  RewardTutorialContainerVC.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RewardTutorialContainerVC.h"
#import "RewardTutorialDetailVC.h"

@interface RewardTutorialContainerVC (){
    UIViewController __weak * _currentChildController;
}
@property (strong, nonatomic) NSMutableArray * allViewControllers;
@end

@implementation RewardTutorialContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Left nav-bar.
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(rewardTutorialBackTap) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.rewardViewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // Do any additional setup after loading the view.
    if(!self.allViewControllers) self.allViewControllers = [[NSMutableArray alloc]init];
    
    // Creating controller for container
    for (int i = 0; i <= kTutorialPagesCount; ++i) {
        RewardTutorialDetailVC * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardTutorialDetailVC"];
        controller.superController = self.rewardViewController;
        controller.pageType = i;
        controller.tutorialContainerVC = self;
        [self.allViewControllers addObject:controller];
    }
    
    self.selectedPageIndex = 0;
    [self cycleFromViewController:_currentChildController toViewController:[self.allViewControllers objectAtIndex:self.selectedPageIndex]];
}

-(void)cycleControllerToIndex:(NSInteger )controllerIndex{
    self.selectedPageIndex = controllerIndex;
    [self cycleFromViewController:_currentChildController toViewController:[self.allViewControllers objectAtIndex:controllerIndex]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)rewardTutorialBackTap{
    self.rewardViewController.navigationItem.leftBarButtonItem = nil;
    [self.rewardViewController cycleControllerToIndex:0];
}


-(void)dealloc {
    // let's release our child controllers
    for (int i = 0; i <= kTutorialPagesCount; ++i) {
        self.allViewControllers[i] = nil;
    }
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
