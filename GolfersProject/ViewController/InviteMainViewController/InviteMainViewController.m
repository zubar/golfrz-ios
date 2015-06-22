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


@interface InviteMainViewController (){
    NSMutableString * searchString;
    NSArray * searchResults;
    bool isSearching;
    
    NSMutableArray * contacts; // this array will be pointing to the current array whose contacts are displayed.
    NSMutableArray * invities;
}
@end

@implementation InviteMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    searchString = [NSMutableString string];
    searchResults = [NSArray array];
    contacts = [NSMutableArray array];
    invities = [NSMutableArray array];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    ContactCell *customViewCell = (ContactCell *)customCell;
    [customViewCell configureContactCellViewForContact:contact];
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
            [invities addObject:[contact contactEmail]];
            break;
        case 2:
            [invities addObject:[contact contactPhoneNumber]];
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
    [invities removeAllObjects];
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
            /*
            [self loadFacebookFriendsCompletion:^{
                contacts = self.fbFriends;
                [self.contactsTable reloadData];
            }];
            //update buttons
            [self setSegmentControlImagesForSelectedSegment:0];
             */
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

-(void)sendSMSToContacts:(NSArray *)contacts{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = [NSString stringWithFormat:@"Hey lets play Golf by downloading :%@", kAppStoreUrl];
        controller.recipients = invities;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            nil;
        }];
    }
}

//TODO: we shall use backend email service instead. 
-(void)sendEmailToContacts:(NSArray *)contacts{
   
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Invitation to play Golf"];
    [controller setMessageBody:[NSString stringWithFormat:@"Hey lets play Golf by downloading :%@", kAppStoreUrl] isHTML:NO];
    [controller setToRecipients:invities];
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

} // called when keyboard search button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchString  setString:@""];
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
            [invities  removeAllObjects];
            alertTitle = @"User Cancel Action";
            alertMessage = @"You canceled the invitation.";
            break;
        case MessageComposeResultFailed:
            [invities  removeAllObjects];
            alertTitle = @"Failed to send";
            alertMessage = @"Please try again.";
            break;
        case MessageComposeResultSent:
            [invities  removeAllObjects];
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
    }];
}

#pragma mark - Email Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
     NSString * alertTitle = nil;
     NSString * alertMessage = nil;
    
    switch (result) {
        case MFMailComposeResultCancelled:
            [invities  removeAllObjects];
            alertTitle = @"User Cancel Action";
            alertMessage = @"You canceled the invitation.";
            break;
        case MFMailComposeResultFailed:
            [invities  removeAllObjects];
            alertTitle = @"Failed to send";
            alertMessage = @"Please try again.";
            break;
        case MFMailComposeResultSaved:
            [invities  removeAllObjects];
            alertTitle = @"Draft Saved.";
            alertMessage = @"Invitation email is saved in drafts.";
            break;
        case MFMailComposeResultSent:
            [invities  removeAllObjects];
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
    
    if (alertTitle && alertMessage) {
        [[[UIAlertView alloc]initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    
}


#pragma mark - FBInviteFriendDialogue
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
    
}


- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error{
    
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Try Again" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

@end
