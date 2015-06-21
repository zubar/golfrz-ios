//
//  ContactCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/16/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactCellDelegate <NSObject>
-(void)addBtnTapped:(id)contact;
@end


@interface ContactCell : UITableViewCell{
    id currentContact;
}

@property (assign, nonatomic) id<ContactCellDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIImageView *imgContactPic;
@property (strong, nonatomic) IBOutlet UILabel *lblContactName;
@property (weak, nonatomic) IBOutlet UIButton *addbtn;


//UI Actions
-(IBAction)btnAdd:(UIButton *)sender;
-(void)configureContactCellViewForContact:(id)contact;
@end
