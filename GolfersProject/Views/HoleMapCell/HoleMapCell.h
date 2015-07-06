//
//  HoleMapCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HoleMapCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblHoleNo;
@property (strong, nonatomic) IBOutlet UIImageView *imgHoleMao;
@property (strong, nonatomic) IBOutlet UILabel *lblPar;

@end
