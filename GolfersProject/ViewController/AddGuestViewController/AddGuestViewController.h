//
//  AddGuestViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGuestViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtGuestName;
@property (strong, nonatomic) IBOutlet UITextField *txtGuestEmail;
- (IBAction)btnSelectHandicapTapped:(UIButton *)sender;
- (IBAction)btnSelectTeeBoxTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnHandicap;
@property (strong, nonatomic) IBOutlet UIButton *btnTeeBox;
- (IBAction)btnAddGuestTapped:(UIButton *)sender;

@end
