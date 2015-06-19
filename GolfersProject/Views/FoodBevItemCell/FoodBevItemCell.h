//
//  FoodBevItemCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  FoodCellDelegate <NSObject>

-(void) didTapCheckedButtonAtIndexPath:(NSIndexPath*) indexPath;

@end

@interface FoodBevItemCell : UITableViewCell

- (IBAction)btnCheckedTapped:(UIButton *)sender;

@property (weak, nonatomic) id<FoodCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *btnChecked;
@property (strong, nonatomic) IBOutlet UILabel *lblSideItem;

@property (strong, nonatomic) NSIndexPath *indexPath;


@end
