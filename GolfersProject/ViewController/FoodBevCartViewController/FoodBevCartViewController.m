//
//  FoodBevCartViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/15/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "FoodBevCartViewController.h"
#import "FoodBevCartCell.h"
#import "FoodBeverageServices.h"
#import "Cart.h"
#import "Order.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FoodBevCartViewController ()

@end

@implementation FoodBevCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FoodBeverageServices cartItemsForCurrentUser:^(bool status, Cart* responseCart){
        
        self.cartArray = (NSMutableArray* )responseCart.orders;
        
    }failure:^(bool status, NSError* error){
        
    }];
    //self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return [self.cartArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"FoodBevCartCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FoodBevCartCell"];
    }
    
    FoodBevCartCell *customViewCell = (FoodBevCartCell *)customCell;
    Order *cartItem = [self.cartArray objectAtIndex:indexPath.row];
    [customViewCell.imgFoodBevItemPic sd_setImageWithURL:[NSURL URLWithString:cartItem.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //  <#code#>
        [customViewCell.imgFoodBevItemPic setImage:image];
    } ];
    customViewCell.lblFoodBevItemName.text = cartItem.name;
    customViewCell.lblPrice.text = cartItem.price.stringValue;
    customViewCell.lblQuantity.text = cartItem.quantity.stringValue;
    return customViewCell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnPlaceOrderTapped:(UIButton *)sender {
}
@end
