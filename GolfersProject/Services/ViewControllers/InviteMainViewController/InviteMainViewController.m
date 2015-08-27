//
//  InviteMainViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/16/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "InviteMainViewController.h"
#import "ContactCell.h"
#import "ContactServices.h"
#import "MBProgressHUD.h"
#import "APContact+convenience.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "SharedManager.h"

#define kSMSInvites @"phone_Invites"
#define kEmailInvites @"email_Invites"

@interface InviteMainViewController (){
    NSMutableString * searchString;
    NSArray * searchResults;
    bool isSearching;
    
    NSMutableArray * contacts; // this array will be pointing to the current array whose contacts are displayed.
    NSMutableDictionary * invities;
}
@end

@implementation InviteMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Left bar button
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];

    
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(InviteFriendbackBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // Right bar button
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendInvites)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    // Title
    NSDictionary *navTitleAttributes =@{
                                        NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.0],
                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                        };
    
    
    self.navigationItem.title = @"INVITE FRIENDS";
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    self.navigationController.navigationBar.barTintColor = [[SharedManager sharedInstance] themeColor];
    
    
    
    
    // Do any additional setup after loading the view.
    searchString = [NSMutableString string];
    searchResults = [NSArray array];
    contacts = [NSMutableArray array];
    invities = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSMutableArray alloc]init], kEmailInvites,
                                                                    [[NSMutableArray alloc]init], kSMSInvites,
                                                                    nil];
    isSearching = false;
    
    //properties to hold data
    self.fbFriends = [NSMutableArray array];
    self.addressbookContacts = [NSMutableArray array];
    self.inappContacts = [NSMutableArray array];
    
    [self.searchBar setDelegate:self];
    
    [self.segmentControl setSelectedSegmentIndex:1];
    [self setSegmentControlImagesForSelectedSegment:1];
    [self loadDataForSegemnt:1];

}

-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    [delegate.appDelegateNavController.navigationBar setTitleVerticalPositionAdjustment:0.0 forBarMetrics:UIBarMetricsDefault];
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:YES];
}

-(void)InviteFriendbackBtnTapped{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendInvites{
    
    
    switch ([self.segmentControl selectedSegmentIndex]) {
        case 1:
            if ([invities[kEmailInvites] count] <= 0) {
                [self errorMessageNoContactSelected];
                return;
            }
            [self sendEmailToContacts:invities[kEmailInvites]];
            break;
        case 2:
            if ([invities[kSMSInvites] count] <= 0) {
                [self errorMessageNoContactSelected];
                return;
            }
            //TODO:
//            [self sendSMSToContacts:<#(NSArray *)#> text:<#(NSString *)#>]
//            [self sendSMSToContacts:invities[kSMSInvites]];
            break;
        default:
            break;
    }
    
}

-(void)errorMessageNoContactSelected{
    
    [[[UIAlertView alloc] initWithTitle:@"No Contacts Selected" message:@"Please select atleast one contact to sent invite" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

#pragma mark - UITableViewDelagate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return (isSearching ? [searchResults count] : [contacts count]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactCell"];
    }
    
    id contact = (isSearching ? searchResults[indexPath.row] : contacts[indexPath.row]);
    if ([contact associatedObject] == nil) {
        [contact setAssociatedObject:[NSNumber numberWithBool:NO]];
    }


    ContactCell *customViewCell = (ContactCell *)customCell;
    [customViewCell configureContactCellViewForContact:contact];
    
    switch ([self.segmentControl selectedSegmentIndex]) {
        case 1:
            if ([invities[kEmailInvites] containsObject:[contact contactEmail]]) {
                [customViewCell.addbtn setImage:[UIImage imageNamed:@"invitefriend_checked"] forState:UIControlStateNormal];
            }
            break;
        case 2:
            if ([invities[kSMSInvites] containsObject:[contact contactPhoneNumber]]) {
                [customViewCell.addbtn setImage:[UIImage imageNamed:@"invitefriend_checked"] forState:UIControlStateNormal];
            }
            break;
            
        default:
            break;
    }
    
    
    [customViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [customViewCell setDelegate:self];
    
    return customViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - ContactCell Delegate
-(void)addBtnTapped:(id)contact{
    
    
    switch ([self.segmentControl selectedSegmentIndex]) {
        case 1:
            if ([contact associatedObject] == [NSNumber numberWithBool:YES]) {
                [invities[kEmailInvites] addObject:[contact contactEmail]];
            }else{
                [invities[kEmailInvites] removeObject:[contact contactEmail]];
            }
            break;
        case 2:
            if ([contact associatedObject] == [NSNumber numberWithBool:YES]) {
                [invities[kSMSInvites] addObject:[contact contactPhoneNumber]];
            }else{
                [invities[kSMSInvites] removeObject:[contact contactPhoneNumber]];
            }
            break;
        default:
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIActions

- (IBAction)segmentControlTapped:(UISegmentedControl *)sender {
//    [invities removeAllObjects];
    [contacts removeAllObjects];
    
    [self.searchBar resignFirstResponder];
    [searchString  setString:@""];
    [self.searchBar setText:searchString];
    isSearching = false;
    
    [self loadDataForSegemnt:[sender selectedSegmentIndex]];
}

-(void)loadDataForSegemnt:(NSInteger)index{
    switch (index) {
        case 0:{
            
            FBSDKAppInviteContent * content =[[FBSDKAppInviteContent alloc] init];
            content.appLinkURL = [NSURL URLWithString:kAppStoreUrl];
            content.previewImageURL = [NSURL URLWithString:kAppPreviewImage];
            // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
            [FBSDKAppInviteDialog showWithContent:content
                                         delegate:self];
            break;
        }
        case 1:{
            [self loadAddressbookContactsFilterOption:ContactFilterEmail completion:^{
                contacts = self.addressbookContacts;
                [self.contactsTable reloadData];
            }];
            [self setSegmentControlImagesForSelectedSegment:1];
            break;
        }
        case 2:{
            
            [self loadAddressbookContactsFilterOption:ContactFilterPhoneNumber completion:^{
                contacts = self.addressbookContacts;
                [self.contactsTable reloadData];
            }];
            [self setSegmentControlImagesForSelectedSegment:2];
            
            break;
        }
        default:
            break;
    }
}

-(void)setSegmentControlImagesForSelectedSegment:(NSUInteger)index{
    switch (index) {
        case 0:{
            [self.segmentControl setImage:[UIImage imageNamed:@"fb_invite_selected"] forSegmentAtIndex:0];
            [self.segmentControl setImage:[UIImage imageNamed:@"email_invite_unselected"] forSegmentAtIndex:1];
            [self.segmentControl setImage:[UIImage imageNamed:@"sms_invite_unselected"] forSegmentAtIndex:2];
            break;
        }
        case 1:{
            [self.segmentControl setImage:[UIImage imageNamed:@"fb_invite_unselected"] forSegmentAtIndex:0];
            [self.segmentControl setImage:[UIImage imageNamed:@"email_invite_selected"] forSegmentAtIndex:1];
            [self.segmentControl setImage:[UIImage imageNamed:@"sms_invite_unselected"] forSegmentAtIndex:2];
            break;
        }
        case 2:{
            [self.segmentControl setImage:[UIImage imageNamed:@"fb_invite_unselected"] forSegmentAtIndex:0];
            [self.segmentControl setImage:[UIImage imageNamed:@"email_invite_unselected"] forSegmentAtIndex:1];
            [self.segmentControl setImage:[UIImage imageNamed:@"sms_invite_selected"] forSegmentAtIndex:2];
            break;
        }
        default:
            break;
    }
}

#pragma mark - HelperMethods

-(void)sendSMSToContacts:(NSArray *)mContacts text:(NSString *)text{
    
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

-(void)sendEmailToContacts:(NSArray *)mContacts{
   
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Invitation to play Golf"];
    [controller setMessageBody:[NSString stringWithFormat:@"Hey lets play Golf by downloading :%@", kAppStoreUrl] isHTML:NO];
    [controller setToRecipients:mContacts];
    if (controller)
        [self presentViewController:controller animated:YES completion:^{
            nil;
        }];
}

-(void)loadAddressbookContactsFilterOption:(ContactFilterOption)option completion:(void(^)(void))completionBlock{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.addressbookContacts removeAllObjects];
    
        [ContactServices getAddressbookContactsFiltered:option sortedByName:YES success:^(bool status, NSArray *contactsArray) {
            [self.addressbookContacts addObjectsFromArray:contactsArray];
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

-(void)loadFacebookFriendsCompletion:(void (^)(void))completionBlock{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ContactServices getFacebookFriendsFiltered:ContactFilterEmail sortedbyName:YES success:^(bool status, NSArray *friendsArray) {
        if (status) {
            [self.fbFriends addObjectsFromArray:friendsArray];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            completionBlock();
        }
    } failure:^(bool status, NSError *error) {
        NSLog(@"error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        completionBlock();
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


#pragma mark - SearchBarDelegate
// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [searchString setString:[searchText stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (searchString.length >=1) {
        isSearching = true;
        [self filterContentForSearchText:searchString];
        [self.contactsTable reloadData];
    }else{
        isSearching = false;
        [self.contactsTable reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];

} // called when keyboard search button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchString  setString:@""];
    [searchBar setText:searchString];
    isSearching = false;
    [self.contactsTable reloadData];

} // called when cancel button pressed
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{

} // called when search results button pressed


- (void)filterContentForSearchText:(NSString*)searchText //scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"contactFirstName contains[c] %@", searchText];
    searchResults = [contacts filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    return YES;
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
            alertTitle = @"Failed to sent";
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
            [[[UIAlertView alloc]initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        [self removeAllEmailInvites];
        [self.contactsTable reloadData];
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
            alertTitle = @"Failed to sent";
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
            [[[UIAlertView alloc]initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        };
        [self removeAllEmailInvites];
        [self.contactsTable reloadData];
    }];
    
}

-(void)removeAllEmailInvites{
    [invities[kEmailInvites] removeAllObjects];
}

-(void)removeAllSMSInvites{
    [invities[kSMSInvites] removeAllObjects];
}

#pragma mark - FBInviteFriendDialogue
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
 
    //Checking error
    if ([results[@"didComplete"] integerValue] ==1) {
        if ([results[@"completionGesture"] isEqualToString:@"Cancel"]) {
            [[[UIAlertView alloc] initWithTitle:@"User Cancelled" message:@"User cancelled the action" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        
        if ([[results allKeys] count] == 1){
            [[[UIAlertView alloc] initWithTitle:@"Inivites Send" message:@"Send invitations successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }
    [self.segmentControl setSelectedSegmentIndex:1];
    [self setSegmentControlImagesForSelectedSegment:1];
    [self loadDataForSegemnt:1];

}


- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error{
    
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Try Again" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    [self.segmentControl setSelectedSegmentIndex:1];
    [self setSegmentControlImagesForSelectedSegment:1];
    [self loadDataForSegemnt:1];
}

@end
