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
#import "Coordinate.h"
#import "GolfrzError.h"
#import "Utilities.h"
#import "Constants.h"
#import "StaffCell.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];
    
    
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
        [self.staffCollectionView reloadData];
        //[self populateStaffFields];
        [self populateCourseFields];
        [self.staffView setHidden:NO];
        [self.courseInfoView setHidden:NO];
        [self setHiddenAddressFields:NO];

    }
    failure:^(bool status, GolfrzError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
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
    [customViewCell configureViewForDepartment:[self.courseDepartments objectAtIndex:indexPath.row]];
    return customViewCell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.courseStaff.count;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    return CGSizeMake(appFrame.size.width, 100);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StaffCell" forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[UICollectionViewCell alloc] init];
    }
    
    StaffCell *customCell = (StaffCell *)cell;
    StaffMember *currentStaffMember = [self.courseStaff objectAtIndex:indexPath.row];
    [customCell.imgAdminPic sd_setImageWithURL:[NSURL URLWithString:[currentStaffMember imageUrl]] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [customCell.imgAdminPic setRoundedImage:image];
        }
    }];
    
    [customCell.lblAdminName setText:[currentStaffMember name]];
    
    NSDictionary *contactAttributes =@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                       NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:14.0],
                                       NSForegroundColorAttributeName : [UIColor whiteColor]
                                       };
    
    NSAttributedString * adminPhone  = [[NSAttributedString alloc] initWithString:[currentStaffMember phone] attributes:contactAttributes];
    NSAttributedString * adminEmail  = [[NSAttributedString alloc] initWithString:[currentStaffMember email] attributes:contactAttributes];
    [customCell.lblAdminContact setAttributedText:adminPhone];
    [customCell.lblAdminEmail setAttributedText:adminEmail];
    [customCell.lblAdminPost setText:((StaffType*)[currentStaffMember type]).name];
    
    return customCell;
    
}

#pragma mark - Navigation

-(void)backBtnTapped{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController popViewControllerAnimated:YES];
    
}
- (IBAction)viewMapTapped:(id)sender {
    [Utilities viewMap];
}

@end
