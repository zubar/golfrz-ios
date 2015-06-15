//
//  FoodBevCartViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/15/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodBevCartViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *cartTableView;
@property (strong, nonatomic) IBOutlet UITextField *txtLocation;
@property (strong, nonatomic) IBOutlet UITextField *txtMemberNo;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalOrder;

- (IBAction)btnPlaceOrderTapped:(UIButton *)sender;

@end
