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

- (IBAction)btnAdd:(UIButton *)sender {
}

-(void)configureContactCellViewForContact:(id)contact{
 
    [self.lblContactName setText:[contact contactFirstName]];
    
    [self.imgContactPic sd_setImageWithURL:[NSURL  URLWithString:[contact contactImageURL]] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imgContactPic setRoundedImage:image];
    }];
}

@end
