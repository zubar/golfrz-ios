//
//  CourseUpdatesHeaderView.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseUpdatesHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imgCourseLogo;
@property (strong, nonatomic) IBOutlet UIButton *btnKudos;
- (IBAction)btnKudosTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblNoOfKudos;
@property (strong, nonatomic) IBOutlet UILabel *lblCourseUpdateText;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIButton *btnComments;
- (IBAction)btnCommentsTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblNoOfComments;

@end
