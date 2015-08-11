//
//  PastScoreCardsViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/10/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PastScoreCardsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *scoreCardTable;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
