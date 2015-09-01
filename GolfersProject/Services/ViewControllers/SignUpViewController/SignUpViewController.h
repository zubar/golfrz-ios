//
//  SignUpViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblGolfCourseName;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtMemberID;
@property (strong, nonatomic) IBOutlet UITextField *txtHandicapNo;
@property (strong, nonatomic) IBOutlet UILabel *lblTermsOfService;
- (IBAction)btnRegisterTapped:(UIButton *)sender;
- (IBAction)btnBackTapped:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblPrivacyPolicy;

@end
