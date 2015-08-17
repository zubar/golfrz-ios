//
//  HMDataCell.m
//  HomeWorkDiary
//
//  Created by Zubair on 04/08/2014.
//  Copyright (c) 2014 Tkxel. All rights reserved.
//

#import "HMMessageRecieveCell.h"
#import "Comment.h"
#import "Utility.h"
#import "Utilities.h"
#import "UIImageView+RoundedImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "User.h"
#import "User+convenience.h"

@implementation HMMessageRecieveCell
@synthesize recieveDate, messageDetails;
@synthesize DTOObject= _DTOObject;

-(void)setDTOObject:(Comment *)DTOObject
{
    _DTOObject = DTOObject;
    
    [Utilities dateComponentsFromNSDate:[_DTOObject createdAt] components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute) {
        [self.recieveDate setText:timeAndMinute];
    }];
    self.messageDetails.text = _DTOObject.comment;
   
    [self.imgUser sd_setImageWithURL:[NSURL URLWithString:[_DTOObject.user imgPath]] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgUser setRoundedImage:image];
        }
        
    }];
    User * currentUser = _DTOObject.user;
    self.lblUserName.text = currentUser.firstName;
    
    
//    [self.imgUser sd_setImageWithURL:[NSURL URLWithString:[_DTOObject.user imgPath]] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [self.imgUser setRoundedImage:image];
//    }];

    
    //font setting + auto height adjustment
//    int height = [Utility heightRequiredToShowText:_DTOObject.comment forFont:[UIFont fontWithName:@"Helvetica" size:16] inWidth:218];
//    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,height+82-25);
//    self.chatBG.frame = CGRectMake(self.chatBG.frame.origin.x, self.chatBG.frame.origin.y, self.chatBG.frame.size.width , self.frame.size.height-20);
//    self.messageDetails.frame = CGRectMake(self.messageDetails.frame.origin.x, self.messageDetails.frame.origin.y, self.messageDetails.frame.size.width, height+6);
//    self.recieveDate.frame = CGRectMake(self.recieveDate.frame.origin.x,self.chatBG.frame.size.height-self.recieveDate.frame.size.height+10, self.recieveDate.frame.size.width, self.recieveDate.frame.size.height);
    
//    self.messageDetails.font = [UIFont fontWithName:@"Helvetica" size:10];
//    self.recieveDate.font = [UIFont fontWithName:@"Helvetica" size:8];
}


@end
