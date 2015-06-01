//
//  CourseDepartmentCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/28/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDepartmentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblDptName;
@property (strong, nonatomic) IBOutlet UILabel *lblDptContact;
@property (strong, nonatomic) IBOutlet UILabel *lblDptDays;
@property (strong, nonatomic) IBOutlet UILabel *lblDptTimings;

@end
