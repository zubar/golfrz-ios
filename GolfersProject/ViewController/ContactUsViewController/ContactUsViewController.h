//
//  ContactUsViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/28/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
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

@property (strong, nonatomic) IBOutlet UILabel *lblCourseState;
@end
