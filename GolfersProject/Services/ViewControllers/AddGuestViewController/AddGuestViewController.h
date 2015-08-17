//
//  AddGuestViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PopOverView.h"

@interface AddGuestViewController : BaseViewController <UITextFieldDelegate, PopOverViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtGuestFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtGuestLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtGuestEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtGuestHandicap;
@property (weak, nonatomic) IBOutlet UIButton *btnTeeBox;
@property (weak, nonatomic) IBOutlet UIView *addGuestSettingsView;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;
- (IBAction)btnSelectTeeBoxTapped:(UIButton *)sender;
- (IBAction)btnAddGuestTapped:(UIButton *)sender;

@end
