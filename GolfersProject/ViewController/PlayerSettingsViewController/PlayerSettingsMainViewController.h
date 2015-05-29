//
//  PlayerSettingsMainViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/28/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerSettingsMainViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblEditProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblResetPassword;
@property (strong, nonatomic) IBOutlet UIImageView *lblLogout;

@end
