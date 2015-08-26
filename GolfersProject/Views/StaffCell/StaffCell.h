//
//  StaffCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/26/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaffCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgAdminPic;
@property (strong, nonatomic) IBOutlet UILabel *lblAdminName;
@property (strong, nonatomic) IBOutlet UILabel *lblAdminPost;
@property (strong, nonatomic) IBOutlet UILabel *lblAdminEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblAdminContact;

@end
