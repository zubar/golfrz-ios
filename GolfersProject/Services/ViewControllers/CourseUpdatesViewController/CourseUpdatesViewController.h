//
//  CourseUpdatesViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CourseUpdatesViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblUpdates;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;

@end
