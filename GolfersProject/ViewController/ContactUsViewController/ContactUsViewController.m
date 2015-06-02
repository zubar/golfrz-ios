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
#import <SDWebImage/UIImageView+WebCache.h>
#import "StaffMember.h"



@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self populateCourseFields];
    [self populateStaffFields];
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

- (void)populateStaffFields{
    StaffMember *currentStaffMember = [self.courseStaff objectAtIndex:0];
    //StaffType *currentStafType = currentStaffMember.type;
    [self.imgAdminPic sd_setImageWithURL:[NSURL URLWithString:[currentStaffMember imageUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imgAdminPic setImage:image];
    }];
    [self.lblAdminName setText:[currentStaffMember name]];
    [self.lblAdminContact setText:[currentStaffMember phone]];
    [self.lblAdminEmail setText:[currentStaffMember email]];
    
}

- (void) populateCourseFields{
    [self.lblHdrCourseCity setText:[[CourseServices currentCourse]courseCity ] ];
    [self.lblHdrCourseState setText:[[CourseServices currentCourse] courseState]];
    [self.lblCourseStAddress setText:[[CourseServices currentCourse] courseAddress]];
    [self.imgCourseLogo sd_setImageWithURL:[NSURL URLWithString:[[CourseServices currentCourse] courseLogo]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imgCourseLogo setImage:image];
    }];
    [self.lblCourseState setText:[[CourseServices currentCourse] courseState]];
    [self.lblCourseCity setText:[[CourseServices currentCourse] courseCity]];
    //[[self.lblPostalCode setText:[[CourseServices currentCourse] coursePostalCode] ];
    [self.lblCourseName setText:[[CourseServices currentCourse] courseName]];
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
    
    customViewCell.currentDepartment = [self.courseDepartments objectAtIndexedSubscript:indexPath.row];
   
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
