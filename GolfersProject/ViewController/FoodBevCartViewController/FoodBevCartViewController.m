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
<<<<<<< HEAD
#import "SharedManager.h"
#import "MBProgressHUD.h"
#import "UserServices.h"
=======
#import "UserServices.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "FoodBeveragesMainViewController.h"
>>>>>>> feat/GOLFRZ-284

@interface FoodBevCartViewController ()

@end

@implementation FoodBevCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(foodItemBackBtnTap) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    NSDictionary *navTitleAttributes =@{
                                        NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.0],
                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                        };
    
    self.navigationItem.title = @"YOUR CART";
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
   
    //self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    // Do any additional setup after loading the view.
    [self loadDataForCartCompletion:^{
        [self.cartTableView reloadData];
        [self  updateTotalCartPrice];
        [[SharedManager sharedInstance]setCartBadgeCount:[self.cartArray count]];
    }];
}

-(void)viewWillAppear:(BOOL)animated{

    [self.txtMemberNo setText:[NSString stringWithFormat:@"%@",[UserServices currentUserId]]];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
    // Dispose of any resources that can be recreated.
}


-(void)foodItemBackBtnTap{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadDataForCartCompletion:(void(^)(void))completionHandler{
    [FoodBeverageServices cartItemsForCurrentUser:^(bool status, Cart* responseCart){
        self.cartArray = (NSMutableArray* )responseCart.orders;
        completionHandler();
    }failure:^(bool status, NSError* error){
        
    }];
}

-(void)updateTotalCartPrice{
    
    float cartTotlPrice = 0;
    for (Order * order in self.cartArray) {
        cartTotlPrice += [[order price] floatValue] * [[order quantity] integerValue];
    }
    [self.lblTotalOrder setText:[NSString stringWithFormat:@"%0.2f", cartTotlPrice]];
}

#pragma mark - UITableViewDelegate

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
    
    [customViewCell setCurrentOrder:cartItem];
    [customViewCell setDelegate:self];
    
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

-(void)removeButtonTappedForItem:(Order *)item{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FoodBeverageServices removeItemFromCart:item withBlock:^(bool status, NSDictionary* response){
        NSLog(@"Success");
        [self loadDataForCartCompletion:^{
            [self.cartTableView  reloadData];
            //CGRect frame = CGRectMake(self.cartTableView.frame.origin.x, self.cartTableView.frame.origin.y, self.cartTableView.frame.size.width, self.cartTableView.frame.size.height - 82);
            //[self.cartTableView setFrame:frame];
            [self updateTotalCartPrice];
            [[SharedManager sharedInstance]setCartBadgeCount:[self.cartArray count]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } failure:^(bool status, NSError* error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)btnPlaceOrderTapped:(UIButton *)sender {
    
    if (self.cartArray.count && (self.txtLocation.text.length >= 1)){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [FoodBeverageServices confirmOrderWithLocation:[self.txtLocation text] success:^(bool status, NSString* successMessage){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.cartArray removeAllObjects];
            [self.cartTableView reloadData];
            [self.lblTotalOrder setText:@"0"];
            [[[UIAlertView alloc] initWithTitle:nil message:@"Your order has been placed." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            NSLog(@"Successfully ordered");
        } failure:^(bool status, NSError* error){
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please add at least 1 item in cart and add location" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
        
    {
        AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
        for (UIViewController *controller in [delegate.appDelegateNavController viewControllers]) {
            
            if ([controller isKindOfClass:[FoodBeveragesMainViewController class]]) {
                
                [delegate.appDelegateNavController popToViewController:controller animated:YES];
            }
            
        }
        
      
        
    }
       
}
@end
