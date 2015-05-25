//
//  SignInViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/15/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignInViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblForgotPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)btnSignInTapped:(id)sender;

@end
