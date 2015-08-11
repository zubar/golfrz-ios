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
#import "UserServices.h"

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

   // [self.messagesTable registerNib:[UINib nibWithNibName:@"HMMessageSentCell" bundle:nil] forCellReuseIdentifier:@"HMMessageSent"];
    [self.messagesTable registerNib:[UINib nibWithNibName:@"HMMessageRecieveCell" bundle:nil] forCellReuseIdentifier:@"HMMessageRecieve"];
    
    self.navigationItem.title = @"COURSE UPDATES";
    
    //TODO:
    //For Testing.
    notificationId = [NSNumber numberWithInt:17];
    userId = [NSNumber numberWithInteger:[[UserServices currentUserId] integerValue]];
    
    
    //Adding Refresh control
    refrestCtrl = [[UIRefreshControl alloc]init];
    [refrestCtrl setTintColor:[UIColor whiteColor]];
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
    
    static NSString * recieveIdentifier = @"HMMessageRecieve";

    Comment * message = [self.DTOArray objectAtIndex:indexPath.row];
    HMMessageRecieveCell * cell = [tableView dequeueReusableCellWithIdentifier:recieveIdentifier];
    if (!cell) {
        cell=[[HMMessageRecieveCell alloc] init ];
    }
        cell.DTOObject = message;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 30;
//    
////    Comment * messageObj = [self.DTOArray objectAtIndex:indexPath.row];
////    int height = [Utility heightRequiredToShowText:messageObj.comment forFont:[UIFont fontWithName:@"Helvetica" size:10] inWidth:218];
////    return height+70-25;
//}

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
        __block NSString * commentMessage = [[NSString alloc]initWithString:[self.messageWriteField text]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [CourseUpdateServices postComment:[self.messageWriteField text] onPostId:notificationId success:^(bool status, id successMessage) {
                if(status){
                    //add message object in messages array
                    NSDictionary * commentParam = @{
                                                    @"comment" : commentMessage,
                                                    @"createdAt" : [NSDate date],
                                                    @"notificationId" : notificationId,
                                                    @"userId" : [UserServices  currentUserId],
                                                    };
                
                NSError * error = nil;
                Comment * message = [Comment modelWithDictionary:commentParam error:&error];
                if(!error) {
                    [self.DTOArray addObject:message];
                }
                if(self.DTOArray.count > 0){
                    [self.messagesTable setHidden:NO];
                    [self.noRecodFoundLabel setHidden:YES];
                }else{
                    [self.messagesTable setHidden:YES];
                    [self.noRecodFoundLabel setHidden:NO];
                }
                
                [self.messagesTable reloadData];
                NSIndexPath *lastIndexPath = [self lastIndexPath];
                [self.messagesTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            } failure:^(bool status, GolfrzError *error) {
                [self.DTOArray removeLastObject];
                [self.messagesTable reloadData];
                NSIndexPath *lastIndexPath = [self lastIndexPath];
                [self.messagesTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [Utilities displayErrorAlertWithMessage:[error errorMessage]];
            }];
    }
    [self.messageWriteField resignFirstResponder];
    self.messageWriteField.text = @"";
}
-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [self.messagesTable numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [self.messagesTable numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}

#pragma mark text field Delegate

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
