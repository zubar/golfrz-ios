//
//  FoodBevCartCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/15/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Order;

@protocol FoodBevCartCellDelegate <NSObject>
-(void)removeButtonTappedForItem:(Order *)item;
@end


@interface FoodBevCartCell : UITableViewCell{

}

@property (assign, nonatomic) id<FoodBevCartCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *imgFoodBevItemPic;
@property (strong, nonatomic) IBOutlet UILabel *lblFoodBevItemName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;
- (IBAction)btnDismiss:(UIButton *)sender;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) Order * currentOrder;
@end
