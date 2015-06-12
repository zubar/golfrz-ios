//
//  FoodBevViewCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/10/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodBevViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgFoodBev;
@property (strong, nonatomic) IBOutlet UILabel *lblItemName;
@property (strong, nonatomic) IBOutlet UILabel *lblItemPrice;

@end
