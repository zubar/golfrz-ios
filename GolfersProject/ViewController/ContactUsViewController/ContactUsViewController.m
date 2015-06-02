//
//  ContactUsViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/28/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ContactUsViewController.h"
#import "CourseDepartmentCell.h"
#import "MBProgressHUD.h"
#import "CourseServices.h"
#import "Course.h"
#import "Department.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CourseServices courseDetailInfo:^(bool status, Course *currentCourse){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.courseDepartments = currentCourse.departments;
        self.courseStaff = currentCourse.staff;
    }
    failure:^(bool status, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get details" delegate:nil cancelButtonTitle:@"CANCEL" otherButtonTitles:nil, nil] show];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courseDepartments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"CourseDepartmentCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseDepartmentCell"];
    }
    
    CourseDepartmentCell *customViewCell = (CourseDepartmentCell *)customCell;
    
    Department *currentDepartment = [self.courseDepartments objectAtIndex:indexPath.row];
    customViewCell.lblDptName.text = currentDepartment.name;
    customViewCell.lblDptContact.text = currentDepartment.phone;
    
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

@end
