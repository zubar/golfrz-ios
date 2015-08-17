//
//  FoodBevItemDetailViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodBevItemCell.h"
#import "FoodBeverageBaseVC.h"
@class FoodBeverage;

@interface FoodBevItemDetailViewController : FoodBeverageBaseVC<UITableViewDataSource, UITableViewDelegate,FoodCellDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgItemPic;
@property (strong, nonatomic) IBOutlet UILabel *lblIngredients;
@property (strong, nonatomic) IBOutlet UITableView *optionsTableView;
@property (strong, nonatomic) NSArray *sideItems;
@property (strong, nonatomic) IBOutlet UITextField *txtCount;

- (IBAction)btnAddTapped:(UIButton *)sender;
- (IBAction)btnAddToCartTapped:(UIButton *)sender;
- (IBAction)btnDecrementTapped:(UIButton *)sender;

@property (strong, nonatomic) FoodBeverage *selectedItem;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;


@property (strong, nonatomic) IBOutlet UILabel *lblItemName;
@property (strong, nonatomic) IBOutlet UILabel *lblItemPrice;
@property (strong, nonatomic) IBOutlet UIView *optionsView;
@property (strong, nonatomic) IBOutlet UILabel *lblOptions;

@property (strong, nonatomic) IBOutlet UIView *optionsViewHeader;
@end
