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
#import "AppDelegate.h"
#import "StaffType.h"
#import "SharedManager.h"
#import "UIImageView+RoundedImage.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.staffView setHidden:YES];
    [self.courseInfoView setHidden:YES];

    [self setHiddenAddressFields:YES];
    //self.navigationItem.title= @"Contact Us";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [CourseServices courseDetailInfo:^(bool status, Course *currentCourse){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.courseDepartments = currentCourse.departments;
        self.courseStaff = currentCourse.staff;
        [self.tblDept reloadData];
        [self populateStaffFields];
        [self populateCourseFields];
        [self.staffView setHidden:NO];
        [self.courseInfoView setHidden:NO];
        [self setHiddenAddressFields:NO];

    }
    failure:^(bool status, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get details" delegate:nil cancelButtonTitle:@"CANCEL" otherButtonTitles:nil, nil] show];
    }];
    
}

-(void)setHiddenAddressFields:(BOOL)yesNo{
    [self.lblCourseStAddress setHidden:yesNo];
    [self.lblCourseState setHidden:yesNo];
    [self.lblCourseCity setHidden:yesNo];
    [self.lblPostalCode setHidden:yesNo];
    [self.btnViewMap setHidden:yesNo];
    [self.lblComma setHidden:yesNo];
}

-(void)viewWillAppear:(BOOL)animated{
    
     [self.navigationController.navigationBar setHidden:NO];
    
    NSDictionary *titleAttributes =@{
                                     NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.0],
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };

    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[self navigationItem] setTitle:@"CONTACT US"];
    self.navigationController.navigationBar.titleTextAttributes = titleAttributes;
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(backBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
   
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{

    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateStaffFields{
    ([self.courseStaff count] <= 0 ?
    [self.staffView setHidden:YES] : [self.staffView setHidden:NO]);
    
    
    StaffMember *currentStaffMember = [self.courseStaff objectAtIndex:0];
    //StaffType *currentStafType = currentStaffMember.type;    
    [self.imgAdminPic sd_setImageWithURL:[NSURL URLWithString:[currentStaffMember imageUrl]] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgAdminPic setRoundedImage:image];
        }
    }];
    
    [self.lblAdminName setText:[currentStaffMember name]];
    [self.lblAdminContact setText:[currentStaffMember phone]];
    [self.lblAdminEmail setText:[currentStaffMember email]];
    [self.lblAdminPost setText:((StaffType*)[currentStaffMember type]).name];
}

- (void) populateCourseFields{
    [self.lblHdrCourseCity setText:[[CourseServices currentCourse]courseCity ] ];
    [self.lblHdrCourseState setText:[[CourseServices currentCourse] courseState]];
    [self.lblCourseStAddress setText:[[CourseServices currentCourse] courseAddress]];
   
    
    // Setting course logo
    [self.imgCourseLogo sd_setImageWithURL:[NSURL URLWithString:[[CourseServices currentCourse] courseLogo]] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgCourseLogo setRoundedImage:image];
        }
    }];
    
    [self.lblCourseState setText:[[CourseServices currentCourse] courseState]];
    [self.lblCourseCity setText:[[CourseServices currentCourse] courseCity]];
    //[[self.lblPostalCode setText:[[CourseServices currentCourse] coursePostalCode] ];
    [self.lblCourseName setText:[[CourseServices currentCourse] courseName]];
    [self.lblPostalCode setText:[NSString stringWithFormat:@"%@",[[CourseServices currentCourse] postalCode]]];
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
    
    //customViewCell.currentDepartment = [self.courseDepartments objectAtIndexedSubscript:indexPath.row];
    
    [customViewCell configureViewForDepartment:[self.courseDepartments objectAtIndex:indexPath.row]];
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

-(void)backBtnTapped{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController popViewControllerAnimated:YES];
    
}
- (IBAction)viewMapTapped:(id)sender {
    
    //TODO: Open Map
    
   // NSString * destinationAddress = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%@" , @"31.501452,74.315775"];
    
    NSString * destinationAddress = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@" , @"Kalma+Chowk+Bus+Stop,+Lahore,+Punjab,+Pakistan&saddr=31-b+3,+Lahore,+Punjab,+Pakistan"];

    
    //NSString * destSafariAddress = [NSString stringWithFormat:@"<a href=http://maps.apple.com/?daddr=%@> GolfCourse</a>" , @"31 B-III, Gulberg-III, Lahore, Pakistan"];
    
    NSURL * destUrl = [NSURL URLWithString:destinationAddress];
    if (destUrl) {
       // [[UIApplication sharedApplication] openURL:destUrl];
    }
}
@end
