//
//  RoundInviteSendViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RoundInviteFriendViewController.h"
#import "ContactCell.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "InviteMainViewController.h"
#import "ContactServices.h"
#import "APContact+convenience.h"
#import "InvitationServices.h"
#import "AddPlayersViewController.h"
#import "GameSettings.h"
#import "AddPlayersViewController.h"

#import "RoundViewController.h"
#import "AppDelegate.h"
#import "SharedManager.h"
#import "InvitationManager.h"

//TODO: Create a class invitationManager which handles:
/*
    1- Fetching friends from Addressbook, send inivitations to addressbook friends. 
    2- Handle delegates for SMS, Email etc. 
    3- Use that class in RoundInviteSendViewController & InviteMainViewController, removing the friends mechanism from these classes.
 */

@interface RoundInviteFriendViewController ()
@property (nonatomic, strong) NSMutableArray * selectedFriends;
@property (nonatomic, strong) NSMutableArray * allFriends;
@property (nonatomic, strong) NSMutableArray * searchedFriends;
//TODO: save the invitationId if required.
@property (nonatomic, strong) NSString * invitationId;
@end

@implementation RoundInviteFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];

    
    // Remove left button
    [self.navigationItem setTitle:@"SELECT PLAYERS"];
    
     NSDictionary *titleAttributes =@{
                                      NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.0],
                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                      };
    self.navigationController.navigationBar.titleTextAttributes = titleAttributes;
    
    // Do any additional setup after loading the view.
    self.friendsTableView.dataSource = self;
    self.friendsTableView.delegate = self;
    
    if (!self.selectedFriends) {
        self.selectedFriends = [[NSMutableArray alloc] init];
    }
    if (!self.allFriends) {
        self.allFriends = [[NSMutableArray alloc] init];
    }
    
    // Right bar button
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    //
    switch (self.currentFriendContactType) {
        case FriendContactTypeInAppUser:{ // IN-APP FRIENDS
            ([self.allFriends count] > 0 ? [self.allFriends removeAllObjects] : nil);
            [self fetchInAppFriends:^{
                [self.friendsTableView reloadData];
            }];
        }
            break;
        case FriendContactTypeAddressbookEmail:{ // EMAIL
            ([self.allFriends count] > 0 ? [self.allFriends removeAllObjects] : nil);
            [self fetchAddressbookContactsFilterOption:ContactFilterEmail completion:^{
                [self.friendsTableView reloadData];
            }];
        }
            break;
        case FriendContactTypeAddressbookSMS:{ // SMS
            ([self.allFriends count] > 0 ? [self.allFriends removeAllObjects] : nil);
            [self fetchAddressbookContactsFilterOption:ContactFilterPhoneNumber completion:^{
                [self.friendsTableView reloadData];
            }];
        }
            break;
        case FriendContactTypeFacebookEmail:{
            //TODO:
        }
        default:
            break;
    }
    self.searchedFriends = [self.allFriends mutableCopy];
}



-(void)fetchInAppFriends:(void(^)(void))completion{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [InvitationServices getInAppUsers:^(bool status, NSArray *inAppUsers) {
        if (status) {
            [self.allFriends addObjectsFromArray:inAppUsers];
            self.searchedFriends = [self.allFriends mutableCopy];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        completion();
    } failure:^(bool status, GolfrzError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        completion();
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.searchedFriends count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactCell"];
    }
    
    ContactCell *customViewCell = (ContactCell *)customCell;
    customViewCell.delegate = self;
    
    id friendObject = self.searchedFriends[indexPath.row];
    if ([friendObject associatedObject] == nil) {
        [friendObject setAssociatedObject:[NSNumber numberWithBool:NO]];
    }
    [customViewCell configureContactCellViewForContact:friendObject];
    [customViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return customViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id selectedFriend = self.searchedFriends[indexPath.row];
    
    if ([self.selectedFriends containsObject:selectedFriend]) {
        [self.selectedFriends removeObject:selectedFriend];
    }else{
        [self.selectedFriends addObject:selectedFriend];
    }
}
#pragma mark - ServiceCalls
-(void)saveInvitationOnServerCompletion:(void(^)(void))completion{
    
    RoundInvitationType inviteType;
    NSArray * emailSMS;
    
    switch (self.currentFriendContactType) {
        case FriendContactTypeAddressbookSMS:
            inviteType = RoundInvitationTypeSMS;
            emailSMS = [self contactsEmailSMSId:self.selectedFriends option:FriendContactTypeAddressbookSMS];
            break;
        case FriendContactTypeAddressbookEmail:
            inviteType = RoundInvitationTypeEmail;
            emailSMS = [self contactsEmailSMSId:self.selectedFriends option:FriendContactTypeAddressbookEmail];
            break;
        case FriendContactTypeInAppUser:
            inviteType = RoundInvitationTypeInApp;
            emailSMS = [self contactsEmailSMSId:self.selectedFriends option:FriendContactTypeInAppUser];
            break;
        case FriendContactTypeFacebookEmail:
            inviteType = RoundInvitationTypeFacebook;
            break;
        default:
            break;
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [InvitationServices getInvitationTokenForInvitee:emailSMS
                                                type:inviteType
                                             success:^(bool status, NSString *invitationToken) {
                if (status) {
                    self.invitationId = invitationToken;
                    completion();
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                        }
    } failure:^(bool status, NSError *error) {
        //TODO:
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - ContactCellDelegate
-(void)addBtnTapped:(id)contact{
  
    id selectedFriend = contact;
    
    if ([self.selectedFriends containsObject:selectedFriend]) {
        [self.selectedFriends removeObject:selectedFriend];
    }else{
        [self.selectedFriends addObject:selectedFriend];
    }
}


    
-(void)doneTapped{
    [self saveInvitationOnServerCompletion:^{
        NSString * invitationUrl = [InvitationServices getinvitationAppOpenUrlForInvitation:self.invitationId];
        NSLog(@"InvitationUrl: %@", invitationUrl);
        if ([self.allFriends count] > 0) {
            [[GameSettings sharedSettings] setWaitingForPlayers:YES];
            [self sendInvitationsWithMsg:invitationUrl];
        }
    }];
}


-(void)sendInvitationsWithMsg:(NSString *)text{
    
    switch (self.currentFriendContactType) {
        case FriendContactTypeAddressbookSMS:
            [self sendSMSToContacts:[self contactsEmailSMSId:self.selectedFriends option:FriendContactTypeAddressbookSMS]];
            break;
        case FriendContactTypeAddressbookEmail:
            [self sendEmailToContacts:[self contactsEmailSMSId:self.selectedFriends option:FriendContactTypeAddressbookEmail] EmailText:text];
            break;
        case FriendContactTypeInAppUser:
            [self sendEmailToContacts:[self contactsEmailSMSId:self.selectedFriends option:FriendContactTypeAddressbookEmail] EmailText:text];
            break;
        default:
            break;
    }
}

-(NSArray *)contactsEmailSMSId:(NSArray *)userObjects option:(FriendContactType )extractionOption{
    
    if ([userObjects count] <= 0) {
        return [NSArray new];
    }
    
    SEL propertySelector = @selector(nilSymbol);
    
    switch (extractionOption) {
        case FriendContactTypeAddressbookEmail:
        case FriendContactTypeInAppUser:
            propertySelector = NSSelectorFromString(@"contactEmail");
            break;
        case FriendContactTypeAddressbookSMS:
            propertySelector = NSSelectorFromString(@"contactPhoneNumber");
            break;
        case FriendContactTypeFacebookEmail:
            ///TODO:
            break;
        case FriendContactTypeGuest:
            //TODO:
            break;
        default:
            break;
    }

    NSMutableArray * emailSMSArray = [[NSMutableArray alloc] initWithCapacity:[userObjects count]];
    for (id user in userObjects) {
        if ([user respondsToSelector:propertySelector]) {
            [emailSMSArray addObject:[user performSelector:propertySelector]];
        }
    }
    
    return emailSMSArray;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//}

-(void)popToAddPlayersViewController{
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    
    for (UIViewController * controller in [appDelegate.appDelegateNavController viewControllers]) {
        //Do not forget to import AnOldViewController.h
        if ([controller isKindOfClass:[AddPlayersViewController class]]) {
                [appDelegate.appDelegateNavController popToViewController:controller animated:YES];
            break;
        }
    }
}


-(void)fetchAddressbookContactsFilterOption:(ContactFilterOption)option completion:(void(^)(void))completionBlock{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [ContactServices getAddressbookContactsFiltered:option sortedByName:YES success:^(bool status, NSArray *contactsArray) {
        [self.allFriends addObjectsFromArray:contactsArray];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //Run the completion block
        completionBlock();
    } failure:^(bool status, NSError *error) {
        //
        NSLog(@"error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        completionBlock();
    }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


#pragma mark - HelperMethods

-(void)sendSMSToContacts:(NSArray *)mContacts{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = [NSString stringWithFormat:@"Hey lets play Golf by downloading :%@", kAppStoreUrl];
        controller.recipients = mContacts;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            nil;
        }];
    }
}

-(void)sendEmailToContacts:(NSArray *)mContacts EmailText:(NSString *)txt{
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Invitation to play Golf"];
    [controller setMessageBody:txt isHTML:NO];
    [controller setToRecipients:mContacts];
    if (controller)
        [self presentViewController:controller animated:YES completion:^{
            nil;
        }];
}

#pragma mark - SMS Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    __block NSString * alertTitle = nil;
    __block NSString * alertMessage = nil;
    
    switch (result) {
        case MessageComposeResultCancelled:
            alertTitle = @"User Cancel Action";
            alertMessage = @"You canceled the invitation.";
            break;
        case MessageComposeResultFailed:
            alertTitle = @"Failed to send";
            alertMessage = @"Please try again.";
            break;
        case MessageComposeResultSent:
            alertTitle = @"Invitation Send.";
            alertMessage = @"Send the invitation successfully.";
            break;
            
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:^{
        if (alertTitle && alertMessage) {
            [[[UIAlertView alloc]initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        [self.selectedFriends removeAllObjects];
        [self.friendsTableView reloadData];
        [self popToAddPlayersViewController];
    }];
}

#pragma mark - Email Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    NSString * alertTitle = nil;
    NSString * alertMessage = nil;
    
    switch (result) {
        case MFMailComposeResultCancelled:
            alertTitle = @"User Cancel Action";
            alertMessage = @"You canceled the invitation.";
            break;
        case MFMailComposeResultFailed:
            alertTitle = @"Failed to send";
            alertMessage = @"Please try again.";
            break;
        case MFMailComposeResultSaved:
            alertTitle = @"Draft Saved.";
            alertMessage = @"Invitation email is saved in drafts.";
            break;
        case MFMailComposeResultSent:
            alertTitle = @"Invitation Send.";
            alertMessage = @"Send the invitation successfully.";
            break;
        default:
            break;
    }
    
    if (error) {
        alertTitle = @"Error";
        alertMessage = [error localizedDescription];
    }
    
    [controller dismissViewControllerAnimated:YES completion:^{
        if (alertTitle && alertMessage) {
            [[[UIAlertView alloc]initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        };
        [self.selectedFriends removeAllObjects];
        [self.friendsTableView reloadData];
        [self popToAddPlayersViewController];
    }];
}

#pragma mark - SearchBarDelegate
// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        self.searchedFriends = [self.allFriends mutableCopy];
    }
    else {
        [self filterContentForSearchText:searchText];
    }
    [self.friendsTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"contactFirstName contains[c] %@", searchText];
    self.searchedFriends = [[self.allFriends filteredArrayUsingPredicate:resultPredicate] mutableCopy];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    return YES;
}

@end
