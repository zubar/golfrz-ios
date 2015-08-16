//
//  HMMessagesDisplayViewController.h
//  HomeWorkDiary
//
//  Created by M.Mahmood on 22/09/2014.
//  Copyright (c) 2014 Tkxel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Activity.h"

@interface HMMessagesDisplayViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView * commentView;
@property (strong, nonatomic) IBOutlet UITableView *messagesTable;
@property (strong, nonatomic) IBOutlet UITextField * messageWriteField;
@property (strong, nonatomic) IBOutlet UILabel * noRecodFoundLabel;
@property(nonatomic,strong) NSMutableArray * DTOArray;

@property (strong, nonatomic) IBOutlet UIImageView *imgCourseLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblCourseUpdateText;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblNoOfComments;

@property (strong, nonatomic) IBOutlet UIButton *btnKudos;
- (IBAction)btnKudosTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblNoOfKudos;


@property (strong, nonatomic) Activity * currntActivity;

-(IBAction)sendMessage:(id)sender;
@end
