//
//  SignInViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/15/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"


@interface SignInViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblForgotPassword;

- (IBAction)btnSignInTapped:(id)sender;

@end
