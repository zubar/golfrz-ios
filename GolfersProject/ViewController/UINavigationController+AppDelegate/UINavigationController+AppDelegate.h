//
//  UINavigationController+AppDelegate.h
//  GolfersProject
//
//  Created by Zubair on 6/2/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UINavigationController (AppDelegate)


-(void)pushToAppDelegateNavController:(UIViewController *)viewController animated:(BOOL)animated;
-(UIViewController *)popFromAppDelegateNavControllerAnimated:(BOOL)animated;


@end
