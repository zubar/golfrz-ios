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

@interface InviteMainViewController (){
    NSMutableString * searchString;
    NSArray * searchResults;
    bool isSearching;
    
    NSMutableArray * contacts; // this array will be pointing to the current array whose contacts are displayed. 
}
@end

@implementation InviteMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    searchString = [NSMutableString string];
    searchResults = [NSArray array];
    contacts = [NSMutableArray array];
    isSearching = false;
    
    //properties to hold data
    self.fbFriends = [NSMutableArray array];
    self.addressbookContacts = [NSMutableArray array];
    self.inappContacts = [NSMutableArray array];
    
    [self.searchBar setDelegate:self];
    [self.segmentControl setSelectedSegmentIndex:1];

}

-(void)loadAddressbookContactsFilterOption:(ContactFilterOption)option completion:(void(^)(void))completionBlock{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.addressbookContacts count] <=0 ) {
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
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

-(void)loadFacebookFriendsCompletion:(void (^)(void))completionBlock{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ContactServices getFacebookFriendsFiltered:ContactFilterEmail sortedbyName:YES success:^(bool status, NSArray *friendsArray) {
        if (status) {
            [self.fbFriends addObjectsFromArray:friendsArray];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            completionBlock();
        }
    } failure:^(bool status, NSError *error) {
            NSLog(@"error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            completionBlock();
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    return customViewCell;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentControlTapped:(UISegmentedControl *)sender {
    
    switch ([sender selectedSegmentIndex]) {
        case 0:{
            [self loadFacebookFriendsCompletion:^{
                contacts = self.fbFriends;
                [self.contactsTable reloadData];
            }];
            //update buttons
            [self setSegmentControlImagesForSelectedSegment:0];
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

@end
