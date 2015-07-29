//
//  AddGuestViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AddGuestViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextField *txtGuestName;
@property (strong, nonatomic) IBOutlet UITextField *txtGuestEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnHandicap;
@property (strong, nonatomic) IBOutlet UIButton *btnTeeBox;

- (IBAction)btnSelectHandicapTapped:(UIButton *)sender;
- (IBAction)btnSelectTeeBoxTapped:(UIButton *)sender;
- (IBAction)btnAddGuestTapped:(UIButton *)sender;

@end
