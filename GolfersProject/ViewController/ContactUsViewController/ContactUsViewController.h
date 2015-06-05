//
//  ContactUsViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/28/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ContactUsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UILabel *lblCourseName;
@property (strong, nonatomic) IBOutlet UILabel *lblHdrCourseState;
@property (strong, nonatomic) IBOutlet UILabel *lblHdrCourseCity;
@property (strong, nonatomic) IBOutlet UILabel *lblCourseStAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblCourseCity;
@property (strong, nonatomic) IBOutlet UILabel *lblPostalCode;
@property (strong, nonatomic) IBOutlet UILabel *lblViewMap;
@property (strong, nonatomic) IBOutlet UIImageView *imgAdminPic;
@property (strong, nonatomic) IBOutlet UILabel *lblAdminName;
@property (strong, nonatomic) IBOutlet UILabel *lblAdminPost;
@property (strong, nonatomic) IBOutlet UILabel *lblAdminEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblAdminContact;


@property (strong, nonatomic) NSArray *courseStaff;
@property (strong, nonatomic) NSArray *courseDepartments;

@property (strong, nonatomic) IBOutlet UIView *courseInfoView;

@property (strong, nonatomic) IBOutlet UIImageView *imgCourseLogo;
@property (strong, nonatomic) IBOutlet UIView *staffView;

@property (strong, nonatomic) IBOutlet UITableView *tblDept;
@property (strong, nonatomic) IBOutlet UILabel *lblCourseState;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *courseDetailsView;




@end
