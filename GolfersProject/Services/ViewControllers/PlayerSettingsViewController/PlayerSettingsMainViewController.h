//
//  PlayerSettingsMainViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/28/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PlayerSettingsMainViewController : BaseViewController <UITextFieldDelegate>{
    bool isEditing;
}
@property (strong, nonatomic) IBOutlet UILabel *lblEditProfile;

@property (strong, nonatomic) IBOutlet UIImageView *imgUserPic;

@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtHandicap;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnectFB;
@property (weak, nonatomic) IBOutlet UILabel *lblPrivacyPolicy;

@end
