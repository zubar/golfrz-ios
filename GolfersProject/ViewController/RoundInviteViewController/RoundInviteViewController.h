//
//  RoundInviteViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/2/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundInviteViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UITableView *inviteTableView;

@property (strong, nonatomic) NSArray *inviteArrayImages;

@property (strong, nonatomic) NSArray *inviteNames;

@end
