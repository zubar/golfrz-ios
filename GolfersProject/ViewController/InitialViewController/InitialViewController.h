//
//  InitialViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgCourseLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblSignIn; 
@property (weak, nonatomic) IBOutlet UILabel *lblCityState;
@property (weak, nonatomic) IBOutlet UILabel *lblCourseName;

//- (void) setImageCourseLogoRounded;
@property (strong, nonatomic) IBOutlet UIView *backGroundView;

@end
