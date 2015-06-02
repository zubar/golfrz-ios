//
//  CourseDepartmentCell.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/28/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "CourseDepartmentCell.h"
#import "Department.h"

@implementation CourseDepartmentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)configureViewForDepartment:(Department *)departmant{
    self.currentDepartment = departmant;
    
    self.lblDptContact.text = departmant.phone;
    self.lblDptName.text = departmant.name;
}

@end
