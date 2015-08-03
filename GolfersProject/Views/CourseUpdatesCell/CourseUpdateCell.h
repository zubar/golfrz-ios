//
//  CourseUpdateCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseUpdateCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgCourseLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblUpdateText;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIView *commentsView;
@property (strong, nonatomic) IBOutlet UIButton *btnAddComments;
- (IBAction)btnAddCommentsTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblCommentsCount;
@property (strong, nonatomic) IBOutlet UIView *singleImageView;
@property (strong, nonatomic) IBOutlet UIImageView *imgUpdateImage;
@property (strong, nonatomic) IBOutlet UIView *kudosView;
@property (strong, nonatomic) IBOutlet UIImageView *imgKudos;
@property (strong, nonatomic) IBOutlet UILabel *kudosCount;

@end
