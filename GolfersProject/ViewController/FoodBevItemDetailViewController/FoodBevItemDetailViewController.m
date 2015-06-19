//
//  FoodBevItemDetailViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "FoodBevItemDetailViewController.h"
#import "FoodBevItemCell.h"
#import "FoodBeverage.h"
#import "SideItem.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FoodBeverageServices.h"

@interface FoodBevItemDetailViewController ()

@property (strong, nonatomic) NSMutableArray *selectedIds;

@end


@implementation FoodBevItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIds = [NSMutableArray array];
    //self.quantity = 0;
    self.sideItems = self.selectedItem.sideItems;
    [self.imgItemPic sd_setImageWithURL:[NSURL URLWithString:self.selectedItem.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //  <#code#>
        [self.imgItemPic setImage:image];
    } ];
    self.lblItemName.text = self.selectedItem.name;
    self.lblItemPrice.text = self.selectedItem.price.stringValue;
    [self.optionsTableView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sideItems count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"FoodBevItemCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FoodBevItemCell"];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    FoodBevItemCell *customViewCell = (FoodBevItemCell *)customCell;
    customViewCell.indexPath = indexPath;
    [customViewCell setDelegate:self];
    SideItem *sideItem = [self.sideItems objectAtIndex:indexPath.row];
    [customViewCell.lblSideItem setText:sideItem.name];
   
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

- (IBAction)btnAddTapped:(UIButton *)sender {
    
    int count;
    count = [self.txtCount.text intValue];
    count++;
    [self.txtCount setText:[NSString stringWithFormat:@"%d",count]];
}
- (IBAction)btnAddToCartTapped:(UIButton *)sender {
    
    [self.selectedIds addObject:self.selectedItem.foodId];
    [FoodBeverageServices addItemsToCartWithIds:self.selectedIds quantity:[self.txtCount.text integerValue] withBlock:^(bool status, NSDictionary *response) {
        NSLog(@"Success");

    } failure:^(bool status, NSError *error) {
        
    }];
}

- (IBAction)btnDecrementTapped:(UIButton *)sender {
    int count;
    if (self.txtCount.text.intValue == 1) {
        return;
    }
    else{
        count = [self.txtCount.text intValue];
    }
    
    count--;
    [self.txtCount setText:[NSString stringWithFormat:@"%d",count]];
}

#pragma mark --  Food cell delegate

-(void)didTapCheckedButtonAtIndexPath:(NSIndexPath *)indexPath
{
    FoodBevItemCell* cell = (FoodBevItemCell*) [self.optionsTableView cellForRowAtIndexPath:indexPath];

    SideItem *sideItem = [self.selectedItem.sideItems objectAtIndex:indexPath.row];
    NSNumber * sideItemId = [sideItem itemId];
    
    if([self.selectedIds containsObject:sideItemId])
    {
        [self.selectedIds removeObject:sideItemId];
        [cell.btnChecked setImage:[UIImage imageNamed:@"unchecked_checkbox"] forState:UIControlStateNormal];
    }
    else
    {
        [self.selectedIds addObject:sideItemId];
        [cell.btnChecked setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
    }
}
@end
