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
#import "Food.h"
#import "Beverage.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FoodBeveragesMainViewController (){
    bool isFoodItemSelected;
}

@end

@implementation FoodBeveragesMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFoodItemSelected = true;
    [self reverseSelectedStateOfButtons:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FoodBeverageServices getMenu:^(bool status, Menu *currentMenu){
        self.foodArray = [[NSMutableArray alloc] initWithArray:currentMenu.foodItems];
        //[self.foodArray addObjectsFromArray:self.foodArray];
        //[self.foodArray addObjectsFromArray:self.foodArray];
        self.bevArray = [[NSMutableArray alloc] initWithArray:currentMenu.beverageItems];
        [self.foodBevCollectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(bool status, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [[[UIAlertView alloc]initWithTitle:@"Try Again" message:@"Failed to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
     }];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
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
    if (isFoodItemSelected) {
        Food *food_bev_item = [self.foodArray objectAtIndex:indexPath.row];
        [customCell.imgFoodBev sd_setImageWithURL:[NSURL URLWithString:food_bev_item.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             [customCell.imgFoodBev setImage:image];
         }];
        [customCell.lblItemName setText:food_bev_item.name];
        [customCell.lblItemPrice setText:food_bev_item.price.stringValue];
        return customCell;
    }
    else{
        Beverage *food_bev_item = [self.bevArray objectAtIndex:indexPath.row];
        [customCell.imgFoodBev sd_setImageWithURL:[NSURL URLWithString:food_bev_item.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             [customCell.imgFoodBev setImage:image];
         }];
        [customCell.lblItemName setText:food_bev_item.name];
        [customCell.lblItemPrice setText:food_bev_item.price.stringValue];
        return customCell;
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnFoodTapped:(UIButton *)sender {

    if (!isFoodItemSelected) {
        [self switchStateIFoodItemSelected];
            [self reverseSelectedStateOfButtons:YES];
        [self.foodBevCollectionView reloadData];
    }
    /*
    else{
        [self.buttonFood setImage:[UIImage imageNamed:@"unselected-food.png"] forState:UIControlStateNormal];
        [self.foodBevCollectionView reloadData];
    }
     */
}

- (IBAction)btnBevTapped:(UIButton *)sender {
    
    if (isFoodItemSelected) {
        [self switchStateIFoodItemSelected];
        [self reverseSelectedStateOfButtons:NO];
        [self.foodBevCollectionView reloadData];
    }
    
//    else{
//        [sender setImage:[UIImage imageNamed:@"Bev_Unselected"] forState:UIControlStateNormal];
//        //[sender setImage:[UIImage imageNamed:@"Bev_Unselected"] forState:UIControlStateDisabled];
//        [self.foodBevCollectionView reloadData];
//    }
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


@end
