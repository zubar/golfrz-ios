//
//  CourseDepartmentCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/28/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Department;

@interface CourseDepartmentCell : UITableViewCell{

}


-(void)configureViewForDepartment:(Department *)departmant;

@property (strong, nonatomic)    Department * currentDepartment;
@property (strong, nonatomic) IBOutlet UIButton *departmentContactButton;
@property (strong, nonatomic) IBOutlet UILabel *lblDptName;
@property (strong, nonatomic) IBOutlet UILabel *lblDptDays; // Mon - Fri
@property (strong, nonatomic) IBOutlet UILabel *lblDptTimings; // (7am - 7pm)


@end
