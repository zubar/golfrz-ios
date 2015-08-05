//
//  HMMessagesDisplayViewController.m
//  HomeWorkDiary
//
//  Created by M.Mahmood on 22/09/2014.
//  Copyright (c) 2014 Tkxel. All rights reserved.
//

#import "HMMessagesDisplayViewController.h"
#import "MBProgressHUD.h"
#import "HMDataManager.h"
#import "HMTeacherMessagesViewController.h"
#import "DTOMessage.h"
#import "DTOTeacher.h"
#import "HMMessageRecieveCell.h"
#import "HMMessageSentCell.h"
#import "Utility.h"
#import "Message.h"
#import "CoreData+MagicalRecord.h"
#import "Constants.h"
#import "HMAppDelegate.h"

@interface HMMessagesDisplayViewController ()
{
    HMDataManager * sharedDataManager;
    UIRefreshControl * refrestCtrl;
    int originaly;
    int movedY;
    NSArray * tablekeys;
    NSDictionary * keyVAluePairs;
    NSString * selectedTeacherId;
    NSString * selectedTeacherName;
}

@end

@implementation HMMessagesDisplayViewController
@synthesize DTOArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark -- View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.messagesTable registerNib:[UINib nibWithNibName:@"HMMessageSentCell" bundle:nil] forCellReuseIdentifier:@"HMMessageSent"];
    [self.messagesTable registerNib:[UINib nibWithNibName:@"HMMessageRecieveCell" bundle:nil] forCellReuseIdentifier:@"HMMessageRecieve"];
    
//    HMAppDelegate * delegate = (HMAppDelegate *) [UIApplication sharedApplication].delegate;
//    if (delegate.menuVC == nil) {
//        
//        [self updateFrameForSettingNavigationBar];
//    }
    
    
    [self loadMessagesScreenData];
    
    //Adding Refresh control
    refrestCtrl = [[UIRefreshControl alloc]init];
    [self.messagesTable addSubview:refrestCtrl];
    [refrestCtrl addTarget:self action:@selector(webServiceCalling) forControlEvents:UIControlEventValueChanged];
    
    originaly = self.view.center.y;
    movedY = self.view.center.y - 210;
    
    //add keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    HMAppDelegate * delegate = (HMAppDelegate *) [UIApplication sharedApplication].delegate;
    if (delegate.menuVC == nil) {
        
        delegate.navigationController.navigationBarHidden = YES;
        //delegate.navigationController.navigationBar.translucent = YES;
        
        //remove observer for message notification
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kMessageNotificationName object:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    HMAppDelegate * delegate = (HMAppDelegate *) [UIApplication sharedApplication].delegate;
    if (delegate.menuVC == nil) {
        
        delegate.navigationController.navigationBarHidden = NO;
        //delegate.navigationController.navigationBar.translucent = NO;
        
        
        //add observer for message notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotificationReceived:) name:kMessageNotificationName object:nil];
    }
}

#pragma mark -- Notification Received

-(void)messageNotificationReceived:(NSNotification *)notification
{
    [self loadMessagesScreenData];
}

#pragma mark -- Helper Methods

-(void) updateFrameForSettingNavigationBar
{

//    HMAppDelegate * delegate = (HMAppDelegate *) [UIApplication sharedApplication].delegate;
//    
//    CGRect navigationBarFrame = delegate.navigationController.navigationBar.frame;
//    
//    CGRect frame = self.messagesTable.frame;
//    self.messagesTable.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
//    
//    frame = self.commentView.frame;
//    self.commentView.frame = CGRectMake(frame.origin.x, CGRectGetMaxY(self.messagesTable.frame), frame.size.width, frame.size.height);
//    
//    frame = self.noRecodFoundLabel.frame;
//    self.noRecodFoundLabel.frame = CGRectMake(frame.origin.x, frame.origin.y - navigationBarFrame.size.height, frame.size.width, frame.size.height);
}

- (void)loadMessagesScreenData
{
    sharedDataManager = [HMDataManager sharedInstance];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //Check this is a message push notification or naviagtion call from previous controller
    NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"teacher_id"];
    
    if ([data isKindOfClass:[NSString class]] && ![data isEqualToString:@""]) {
        
        selectedTeacherId = data;
        selectedTeacherName = [[NSUserDefaults standardUserDefaults] objectForKey:@"teacher_name"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"teacher_id"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"teacher_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        selectedTeacherId = [HMTeacherMessagesViewController selectedTeacherId];
        selectedTeacherName = [HMTeacherMessagesViewController selectedTeacherName];
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:sharedDataManager.userToken, @"token", sharedDataManager.userId, @"parent_id", selectedTeacherId, @"teacher_id", nil];
    
    [sharedDataManager getParentMessages:dic WithBlock:^(BOOL success, NSError *error, NSArray *array) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(success)
        {
            self.DTOArray = [NSMutableArray arrayWithArray:[Utility sortArrayUsingDate:array InAscendingOrder:YES]];
            keyVAluePairs = [Utility getFormattedData:self.DTOArray];
            tablekeys = [keyVAluePairs allKeys];
            tablekeys = [Utility sortDateArrayWithDecendingOrder:tablekeys];
            
            if(self.DTOArray.count > 0)
            {
                [self.messagesTable setHidden:NO];
                [self.noRecodFoundLabel setHidden:YES];
            }
            else
            {
                [self.messagesTable setHidden:YES];
                [self.noRecodFoundLabel setHidden:NO];
            }
            
            [self.messagesTable reloadData];
            
            if(keyVAluePairs.count > 0 && tablekeys.count > 0)
            {
                if(((NSArray*)[keyVAluePairs objectForKey:[tablekeys objectAtIndex:tablekeys.count-1]]).count > 0)
                
                [self.messagesTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:((NSArray*)[keyVAluePairs objectForKey:[tablekeys objectAtIndex:tablekeys.count-1]]).count-1 inSection:tablekeys.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
        }
        else
        {
            [Utility showAlertViewWithTitle:kServerErrorTitle AndMessage:kServerErrorMessage];
        }
    }];
    
    self.navigationItem.title = selectedTeacherName;
    self.messageWriteField.textColor = [UIColor blackColor];
    self.messageWriteField.font = [UIFont fontWithName:@"GothamBook" size:14];
    
}

-(void)reloadInputViews
{
    [self loadMessagesScreenData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

-(void)webServiceCalling
{
    //Call webservice here
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:2];
}

- (void)refreshTable {
    
    
    [refrestCtrl endRefreshing];
    [self.messagesTable reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableviewDatasource & Datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * sendIdentifier = @"HMMessageSent";
    static NSString * recieveIdentifier = @"HMMessageRecieve";
    
    NSString  * key = [tablekeys objectAtIndex:indexPath.section];
    NSArray * aarr = [keyVAluePairs objectForKey:key];

    DTOMessage * message = [aarr objectAtIndex:indexPath.row];
    UITableViewCell * tableCell = nil;
    if([message.sentBy isEqualToString:@"parent"])
    {
        HMMessageSentCell * cell = [tableView dequeueReusableCellWithIdentifier:sendIdentifier];
        if (!cell) {
            cell=[[HMMessageSentCell alloc] init ];
        }
        cell.DTOObject = message;
        tableCell = cell;
    }
    else
    {
        HMMessageRecieveCell * cell = [tableView dequeueReusableCellWithIdentifier:recieveIdentifier];
        if (!cell) {
            cell=[[HMMessageRecieveCell alloc] init ];
        }
        cell.DTOObject = message;
        tableCell = cell;
    }
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString  * key = [tablekeys objectAtIndex:indexPath.section];
    NSArray * aarr = [keyVAluePairs objectForKey:key];
    DTOMessage * messageObj = [aarr objectAtIndex:indexPath.row];
    int height = [Utility heightRequiredToShowText:messageObj.text forFont:[UIFont fontWithName:@"GothamBook" size:16] inWidth:218];
    
    return height+82-25;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString  * key = [tablekeys objectAtIndex:section];
    NSArray * aarr = [keyVAluePairs objectForKey:key];
    
    return  aarr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tablekeys.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,40)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_date.png"]];
    //UIView * backgroundView = [[UIView alloc]init];
    //[backgroundView setBackgroundColor:[UIColor colorWithRed:251/255.0 green:234/255.0 blue:25/255.0 alpha:1.0f]];
    imageView.frame = CGRectMake(0, 0, 111, 36);
    imageView.center = CGPointMake(320/2, 18);
    [headerView addSubview:imageView];
    
    UILabel * label  = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"GothamBook" size:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = [Utility convertDate:[tablekeys objectAtIndex:section] fromFormat:@"dd/MM/yy" InFormat:@"dd-MMM-yyyy"];
    [headerView addSubview:label];
    return headerView;
}

#pragma mark text button action listener
-(IBAction)sendMessage:(id)sender
{
    //Temp Code for adding new object of message
    if(self.messageWriteField.text.length>0)
    {
        
        sharedDataManager = [HMDataManager sharedInstance];
        
        //create message dictionary and add it on server using POST request
        NSMutableDictionary * messageDictionary = [[NSMutableDictionary alloc]init];
        
        //[messageDictionary setObject:self.messageWriteField.text forKey:@"text"];
        //[messageDictionary setObject:[Utility getCurrentDateAndTime] forKey:@"dateTime"];
        //[messageDictionary setObject:[NSNumber numberWithInt:31] forKey:@"child_id"];
        //[messageDictionary setObject:[NSNumber numberWithInt:31] forKey:@"sender_id"];
        
        [messageDictionary setObject:sharedDataManager.userId forKey:@"user_id"];
        [messageDictionary setObject:sharedDataManager.userToken forKey:@"token"];
        [messageDictionary setObject:selectedTeacherId forKey:@"teacher_id"];
        [messageDictionary setObject:self.messageWriteField.text forKey:@"message"];
        [messageDictionary setObject:@"parent" forKey:@"sentby"];
        
        
       // [messageDictionary setObject:[HMTeacherMessagesViewController selectedTeacher].teacherId forKey:@"teacher_id"];
        
        
        [sharedDataManager addMessage:messageDictionary WithBlock:^(BOOL success, NSError *error) {
            //NSLog(@"%@", response);
            
            if(!success)
            {
                [Utility showAlertViewWithTitle:kMessageNotSentErrorTitle AndMessage:kMessageNotSentErrorMessage];
            }
            
            
        }];
        
//        //add message object in core data
//        Message * mrMessage = [Message createEntity];
//        mrMessage.text = self.messageWriteField.text;
//        mrMessage.dateTime = [Utility getCurrentDateAndTime];
//      //  mrMessage.teacherId = [HMTeacherMessagesViewController selectedTeacher].teacherId;
//        mrMessage.studentId = [NSNumber numberWithInt:1122];
//        mrMessage.senderId = [NSNumber numberWithInt:1122];
//        mrMessage.lastUpdate = [[Message findFirst] lastUpdate];
//        
//        
//        //save context state after adding message entity
//        [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:nil];
//        
//        
        //add message object in messages array
        DTOMessage * message = [[DTOMessage alloc] init];
        message.text = self.messageWriteField.text;
        message.dateTime = [Utility getCurrentDateAndTime];
        message.dateAssigned = message.dateTime;
        message.teacherId = nil;
        message.senderId = nil;
        message.studentId = nil;
        message.sentBy = @"parent";
        [self.DTOArray addObject:message];
        
        
        NSMutableArray * arrayNEW = [NSMutableArray arrayWithArray:[Utility sortArrayUsingDate:self.DTOArray InAscendingOrder:YES]];
        keyVAluePairs = [Utility getFormattedData:arrayNEW];
        tablekeys = [keyVAluePairs allKeys];
        tablekeys = [Utility sortDateArrayWithDecendingOrder:tablekeys];
        
        if(self.DTOArray.count > 0)
        {
            [self.messagesTable setHidden:NO];
            [self.noRecodFoundLabel setHidden:YES];
        }
        else
        {
            [self.messagesTable setHidden:YES];
            [self.noRecodFoundLabel setHidden:NO];
        }
        
        [self.messagesTable reloadData];
        
        [self.messagesTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:((NSArray*)[keyVAluePairs objectForKey:[tablekeys objectAtIndex:tablekeys.count-1]]).count-1 inSection:tablekeys.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    //[UIView animateWithDuration:0.1 animations:^(void){
        //self.view.center = CGPointMake(self.view.center.x, originaly);
   // }];
    
    [self.messageWriteField resignFirstResponder];
    self.messageWriteField.text = @"";
}

#pragma mark text field Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [UIView animateWithDuration:0.3 animations:^(void){
//            self.view.center = CGPointMake(self.view.center.x, movedY);
//    }];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [UIView animateWithDuration:0.1 animations:^(void){
//        self.view.center = CGPointMake(self.view.center.x, originaly);
//    }];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Keyboard Notifications

- (void) keyboardWillShow: (NSNotification *)notification
{
    UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    //update frames
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    _commentView.frame = CGRectMake(0.0f, self.view.frame.size.height - keyboardBounds.size.height - _commentView.frame.size.height,_commentView.frame.size.width, _commentView.frame.size.height);
    [self.view bringSubviewToFront:_commentView];
    [UIView commitAnimations];
    
}

- (void) keyboardWillHide: (NSNotification *)notification
{
    CGFloat addCommentViewY = self.view.frame.size.height - 46.0f;
    CGRect tableviewFrame = _messagesTable.frame;
    tableviewFrame.origin.y = 0.0f;
    tableviewFrame.size.height = addCommentViewY - tableviewFrame.origin.y;
    
    UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //update frames
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    _commentView.frame = CGRectMake(0.0f, addCommentViewY, _commentView.frame.size.width, _commentView.frame.size.height);
    //_messagesTable.frame = tableviewFrame;
    [UIView commitAnimations];
    
}


@end
