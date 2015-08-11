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


@property (strong, nonatomic) Activity * currntActivity;

-(IBAction)sendMessage:(id)sender;
@end
