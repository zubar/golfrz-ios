//
//  ContactCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/16/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *imgContactPic;
@property (strong, nonatomic) IBOutlet UILabel *lblContactName;
- (IBAction)btnAdd:(UIButton *)sender;

@end
