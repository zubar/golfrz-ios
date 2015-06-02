//
//  UINavigationController+AppDelegate.m
//  GolfersProject
//
//  Created by Zubair on 6/2/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "UINavigationController+AppDelegate.h"
#import "AppDelegate.h"

@implementation UINavigationController (AppDelegate)



-(void)pushToAppDelegateNavController:(UIViewController *)viewController animated:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController pushViewController:viewController animated:animated];
    
}

-(UIViewController *)popFromAppDelegateNavControllerAnimated:(BOOL)animated{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    return  [delegate.appDelegateNavController popViewControllerAnimated:animated];
}
@end
