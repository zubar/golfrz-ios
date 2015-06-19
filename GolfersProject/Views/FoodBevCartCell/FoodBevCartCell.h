//
//  FoodBevCartCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/15/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodBevCartCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgFoodBevItemPic;
@property (strong, nonatomic) IBOutlet UILabel *lblFoodBevItemName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;
- (IBAction)btnDismiss:(UIButton *)sender;

@end
