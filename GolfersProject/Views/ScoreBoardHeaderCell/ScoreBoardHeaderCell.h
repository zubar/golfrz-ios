//
//  ScoreBoardHeaderCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 8/4/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreBoardHeaderCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblHeading;
@property (strong, nonatomic) IBOutlet UIImageView *imgLeftImage;
@property (strong, nonatomic) IBOutlet UIImageView *imgRightImage;
@property (weak, nonatomic) IBOutlet UIView *handiCpLblView;
@property (weak, nonatomic) IBOutlet UILabel *handiCpLbl;
@property (weak, nonatomic) IBOutlet UIView *dotView;

@end
