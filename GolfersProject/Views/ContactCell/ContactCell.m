//
//  ContactCell.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 6/16/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ContactCell.h"
#import "APContact+convenience.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+RoundedImage.h"



@implementation ContactCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnAdd:(UIButton *)sender{
    
    if ([currentContact associatedObject] == [NSNumber numberWithBool:YES]) {
        [currentContact setAssociatedObject:[NSNumber numberWithBool:NO]];
        [self.addbtn setImage:[UIImage imageNamed:@"invitefriend_unchecked"] forState:UIControlStateNormal];
    }else{
        [currentContact setAssociatedObject:[NSNumber numberWithBool:YES]];
        [self.addbtn setImage:[UIImage imageNamed:@"invitefriend_checked"] forState:UIControlStateNormal];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addBtnTapped:)]) {
        [self.delegate addBtnTapped:currentContact];
    }
}


-(void)configureContactCellViewForContact:(id)contact{
    
    // By Default every contact is unchecked.
    currentContact = contact;
    
    
    if ([currentContact associatedObject] == [NSNumber numberWithBool:YES]) {
        [self.addbtn setImage:[UIImage imageNamed:@"invitefriend_checked"] forState:UIControlStateNormal];
    }else{
        [self.addbtn setImage:[UIImage imageNamed:@"invitefriend_unchecked"] forState:UIControlStateNormal];
    }

    NSString * firstName = ([currentContact contactFirstName] ? [currentContact contactFirstName] : @"" );
    NSString * lastName = ([currentContact contactLastName] ? [currentContact contactLastName] : @"" );

    
    NSString * fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    [self.lblContactName setText:fullName];
    
    if (![currentContact contactImage]) {
        [self.imgContactPic setRoundedImage:[UIImage imageNamed:@"person_placeholder"]];
    }else{
        [self.imgContactPic setRoundedImage:[currentContact contactImage]];
    }
    
    /*
    [self.imgContactPic sd_setImageWithURL:[NSURL  URLWithString:[contact contactImageURL]] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imgContactPic setRoundedImage:image];
    }];
     */
}
@end
