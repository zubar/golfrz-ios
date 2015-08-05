//
//  HMMessagesDisplayViewController.m
//  HomeWorkDiary
//
//  Created by M.Mahmood on 22/09/2014.
//  Copyright (c) 2014 Tkxel. All rights reserved.
//

#import "HMMessagesDisplayViewController.h"
#import "MBProgressHUD.h"
#import "Comment.h"
#import "HMMessageRecieveCell.h"
#import "HMMessageSentCell.h"
#import "Utility.h"
#import "Constants.h"
#import "UserServices.h"
#import "CourseUpdateServices.h"
#import "GolfrzError.h"
#import "Post.h"
#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>

@interface HMMessagesDisplayViewController ()
{
    UIRefreshControl * refrestCtrl;
    int originaly;
    int movedY;
    NSArray * tablekeys;
    NSNumber * notificationId;
    NSNumber * userId;
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
    if(!self.DTOArray) self.DTOArray = [[NSMutableArray alloc] init];

    [self.messagesTable registerNib:[UINib nibWithNibName:@"HMMessageSentCell" bundle:nil] forCellReuseIdentifier:@"HMMessageSent"];
    [self.messagesTable registerNib:[UINib nibWithNibName:@"HMMessageRecieveCell" bundle:nil] forCellReuseIdentifier:@"HMMessageRecieve"];
    
    self.navigationItem.title = @"COURSE UPDATES";
    
    //TODO:
    //For Testing.
    notificationId = [NSNumber numberWithInt:17];
    userId = [NSNumber numberWithInteger:[[UserServices currentUserId] integerValue]];
    
    
    //Adding Refresh control
    refrestCtrl = [[UIRefreshControl alloc]init];
    [refrestCtrl setBackgroundColor:[UIColor whiteColor]];
    [self.messagesTable addSubview:refrestCtrl];
    [refrestCtrl addTarget:self action:@selector(webServiceCalling) forControlEvents:UIControlEventValueChanged];
    
    originaly = self.view.center.y;
    movedY = self.view.center.y - 210;
    
    //add keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadMessagesUpdateView:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
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

- (void)loadMessagesUpdateView:(void(^)(void))completion
{
    [CourseUpdateServices getCommentsOnPostId:notificationId success:^(bool status, Post *mPost) {
        if(status){
            if([self.DTOArray count] > 0 ) [self.DTOArray removeAllObjects];
            [self.DTOArray addObjectsFromArray:mPost.comments];
            //TODO: sort dtoarray here
            if(self.DTOArray.count > 0){
                [self.messagesTable setHidden:NO];
                [self.noRecodFoundLabel setHidden:YES];
            }else{
                [self.messagesTable setHidden:YES];
                [self.noRecodFoundLabel setHidden:NO];
            }
            [self.messagesTable reloadData];
            completion();
        }
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
    }];

    self.messageWriteField.textColor = [UIColor blackColor];
    self.messageWriteField.font = [UIFont fontWithName:@"Helvetica" size:14];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

-(void)webServiceCalling
{
    //Call webservice here
    [CourseUpdateServices getCommentsOnPostId:notificationId success:^(bool status, Post *mPost) {
        [self performSelector:@selector(refreshTable)];
//        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:1];
    } failure:^(bool status, GolfrzError *error) {
        [self performSelector:@selector(refreshTable)];
    }];
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
    

    Comment * message = [self.DTOArray objectAtIndex:indexPath.row];
    UITableViewCell * tableCell = nil;
    if([message.userId isEqualToNumber:userId]){
        HMMessageSentCell * cell = [tableView dequeueReusableCellWithIdentifier:sendIdentifier];
        if (!cell) {
            cell=[[HMMessageSentCell alloc] init ];
        }
        cell.commentObject = message;
        tableCell = cell;
    }else{
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
    
    Comment * messageObj = [self.DTOArray objectAtIndex:indexPath.row];
    int height = [Utility heightRequiredToShowText:messageObj.comment forFont:[UIFont fontWithName:@"Helvetica" size:16] inWidth:218];
    return height+82-25;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.DTOArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*
     * Section is one the section will only contains the subject of discussion.
     */
    return 1;
}

/*
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
    label.font = [UIFont fontWithName:@"Helvetica" size:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = [Utility convertDate:[tablekeys objectAtIndex:section] fromFormat:@"dd/MM/yy" InFormat:@"dd-MMM-yyyy"];
    [headerView addSubview:label];
    return headerView;
}
*/

#pragma mark text button action listener
-(IBAction)sendMessage:(id)sender
{
    //Temp Code for adding new object of message
    if(self.messageWriteField.text.length>0)
    {
        //TODO:
        // Call API here.
        
        //add message object in messages array
        NSDictionary * commentParam = @{
                                        };
        NSError * error = nil;
        Comment * message = [Comment modelWithDictionary:commentParam error:&error];
        [self.DTOArray addObject:message];
        
        if(self.DTOArray.count > 0){
            [self.messagesTable setHidden:NO];
            [self.noRecodFoundLabel setHidden:YES];
        }else{
            [self.messagesTable setHidden:YES];
            [self.noRecodFoundLabel setHidden:NO];
        }
        
        [self.messagesTable reloadData];
        
    NSIndexPath * lastCommentIndex = [NSIndexPath indexPathForRow:[self.DTOArray count]-1 inSection:0];
  //  [self.messagesTable scrollToRowAtIndexPath:lastCommentIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
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
