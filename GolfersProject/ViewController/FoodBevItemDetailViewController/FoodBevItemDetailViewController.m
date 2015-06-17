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

@interface FoodBevItemDetailViewController ()



@end

BOOL isNotSelected = false;

@implementation FoodBevItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.quantity = 0;
    self.sideItems = self.selectedItem.sideItems;
    [self.imgItemPic sd_setImageWithURL:[NSURL URLWithString:self.selectedItem.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //  <#code#>
        [self.imgItemPic setImage:image];
    } ];
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
    SideItem *sideItem = [self.sideItems objectAtIndex:indexPath.row];
    //NSString *sideItemName =
    [customViewCell.lblSideItem setText:sideItem.name];
    //[customViewCell.imgCheckBox setImage:[UIImage imageNamed:@"unchecked_checkbox"]];
    customViewCell.imgCheckBox.image = [UIImage imageNamed:@"unchecked_checkbox"];
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapped.numberOfTapsRequired = 1;
    [customViewCell.imgCheckBox addGestureRecognizer:tapped];
    customViewCell.imgCheckBox.userInteractionEnabled = YES;
    return customViewCell;
}

-(void)imageTapped:(UIGestureRecognizer*)gesture
{
    
    UIImageView *selectedImageView=(UIImageView*)[gesture view];
    
    //UIImage *imageDefault = [UIImage imageNamed:@"checkmark.png"];
    UIImage *imageNotSelected = [UIImage imageNamed:@"unchecked_checkbox"];
    UIImage *imageSelected = [UIImage imageNamed:@"checked_checkbox"];
    //BOOL isSelected = false;
    if (isNotSelected) {
        selectedImageView.image = imageSelected;
        //cell.selected = true;
        isNotSelected = false;
        NSLog(@"Selected");
    } else {
        selectedImageView.image = imageNotSelected;
        isNotSelected = true;
        //cell.selected = false;
        NSLog(@"Deselected");
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

- (IBAction)btnAddTapped:(UIButton *)sender {
    
    int count;
    count = [self.txtCount.text intValue];
    count++;
    [self.txtCount setText:[NSString stringWithFormat:@"%d",count]];
}
- (IBAction)btnAddToCartTapped:(UIButton *)sender {
    
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
@end
