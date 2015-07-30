//
//  FoodBeveragesMainViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/8/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//
#import "FoodBeveragesMainViewController.h"
#import "FoodBevViewCell.h"
#import "FoodBeverageServices.h"
#import "Menu.h"
#import "FoodBeverage.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FoodBevItemDetailViewController.h"
#import "AppDelegate.h"
#import "SharedManager.h"
#import <QuartzCore/QuartzCore.h>
#import "BBBadgeBarButtonItem.h"
#import "FoodBevCartViewController.h"
#import "Utilities.h"
#import "GolfrzError.h"

@interface FoodBeveragesMainViewController (){
    bool isFoodItemSelected;
}

@end

@implementation FoodBeveragesMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"FOOD & BEV";
   
    
    
    isFoodItemSelected = true;
    [self reverseSelectedStateOfButtons:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FoodBeverageServices getMenu:^(bool status, Menu *currentMenu){
        self.foodArray = [[NSMutableArray alloc] initWithArray:currentMenu.foodItems];
        self.bevArray = [[NSMutableArray alloc] initWithArray:currentMenu.beverageItems];
        [self.foodBevCollectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(bool status, GolfrzError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [Utilities displayErrorAlertWithMessage:[error errorMessage]];
     }];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (isFoodItemSelected) {
        return [self.foodArray count];
    }else{
        return [self.bevArray count];
    }
}

//- (CGSize)collectionView:(UICollectionView )collectionView layout:(UICollectionViewLayout )collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(Main_Screen_Width / 2, cellHeight);
//}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    return CGSizeMake(appFrame.size.width / 2, 100);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FoodBevCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UICollectionViewCell alloc]init];
    }
    FoodBevViewCell *customCell = (FoodBevViewCell *)cell;
    
    FoodBeverage * food_bev_item = (isFoodItemSelected ? [self.foodArray objectAtIndex:indexPath.row] : [self.bevArray objectAtIndex:indexPath.row] );
    
    [customCell.imgFoodBev sd_setImageWithURL:[NSURL URLWithString:food_bev_item.imageUrl] placeholderImage:[UIImage imageNamed:@"foodbev_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         [customCell.imgFoodBev setImage:image];
     }];
    [customCell.lblItemName setText:food_bev_item.name];
    [customCell.lblItemPrice setText:food_bev_item.price.stringValue];
    return customCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    FoodBeverage * food_bev_item = (isFoodItemSelected ? [self.foodArray objectAtIndex:indexPath.row] : [self.bevArray objectAtIndex:indexPath.row] );
    [self performSegueWithIdentifier:@"segueItemDetail" sender:food_bev_item];
    
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueItemDetail"]) {
        FoodBevItemDetailViewController *foodBevItemDetailViewController = segue.destinationViewController;
        foodBevItemDetailViewController.selectedItem = sender;
   }    
}


- (IBAction)btnFoodTapped:(UIButton *)sender {

    if (!isFoodItemSelected) {
        [self switchStateIFoodItemSelected];
            [self reverseSelectedStateOfButtons:YES];
        [self.foodBevCollectionView reloadData];
    }
}

- (IBAction)btnBevTapped:(UIButton *)sender {
    
    if (isFoodItemSelected) {
        [self switchStateIFoodItemSelected];
        [self reverseSelectedStateOfButtons:NO];
        [self.foodBevCollectionView reloadData];
    }
}

#pragma mark - Helper Method
-(void)switchStateIFoodItemSelected{
    if (isFoodItemSelected) {
        isFoodItemSelected = false;
    }else{
        isFoodItemSelected = true;
    }
}

-(void)reverseSelectedStateOfButtons:(BOOL)yesNo{
    [self setFoodBtnImageSelected:yesNo];
    [self setBeverageBtnImageSelected:!yesNo];
}

-(void)setFoodBtnImageSelected:(BOOL)yesNo{

    if (yesNo) {
        [self.buttonFood setImage:[UIImage imageNamed:@"select-food"] forState:UIControlStateNormal];
    }else{
        [self.buttonFood setImage:[UIImage imageNamed:@"unselect-food"] forState:UIControlStateNormal];
    }
}

-(void)setBeverageBtnImageSelected:(BOOL)yesNo{
    if (yesNo) {
        [self.buttonBeverage setImage:[UIImage imageNamed:@"select-beverage"] forState:UIControlStateNormal];
    }else{
        [self.buttonBeverage setImage:[UIImage imageNamed:@"unselect-beverage"] forState:UIControlStateNormal];
    }
}

-(void)backButtonTap{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController popViewControllerAnimated:YES];
}

-(void)cartButtonTap{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    FoodBevCartViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodBevCartViewController"];
    [delegate.appDelegateNavController pushViewController:controller animated:YES];

}

@end
