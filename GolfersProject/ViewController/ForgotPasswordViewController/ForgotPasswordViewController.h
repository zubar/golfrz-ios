//
//  ForgotPasswordViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/19/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController
- (IBAction)btnResetPasswordTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailAddress;
- (IBAction)btnBackButtonTapped:(UIButton *)sender;

@end
