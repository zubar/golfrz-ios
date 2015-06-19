//
//  InviteMainViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/16/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

- (IBAction)segmentControlTapped:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *contactsTable;

@property (strong, nonatomic) NSMutableArray * addressbookContacts;
@property (strong, nonatomic) NSMutableArray * fbFriends;
@property (strong, nonatomic) NSMutableArray * inappContacts;

@end
