//
//  HMDataCell.m
//  HomeWorkDiary
//
//  Created by Zubair on 04/08/2014.
//  Copyright (c) 2014 Tkxel. All rights reserved.
//

#import "HMMessageSentCell.h"
#import "Utility.h"
#import "NSDate+Helper.h"
#import "Utilities.h"
#import "UIImageView+RoundedImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "User.h"

@implementation HMMessageSentCell
@synthesize sentDate, messageDetails;
@synthesize commentObject = _commentObject;

-(void)setDTOObject:(Comment *)message
{
    _commentObject = message;
    
    [Utilities dateComponentsFromNSDate:[_commentObject createdAt] components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute) {
        [self.sentDate setText:timeAndMinute];
    }];
    self.messageDetails.text = _commentObject.comment;
    
    [self.imgViewUser sd_setImageWithURL:[NSURL URLWithString:[_commentObject.user imgPath]] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imgViewUser setRoundedImage:image];
    }];
    
    //font setting + auto height adjustment
    int height = [Utility heightRequiredToShowText:_commentObject.comment forFont:[UIFont fontWithName:@"Helvetica" size:16] inWidth:218];
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,height+82-25);
    self.chatBG.frame = CGRectMake(self.chatBG.frame.origin.x, self.chatBG.frame.origin.y, self.chatBG.frame.size.width , self.frame.size.height-20);
    self.messageDetails.frame = CGRectMake(self.messageDetails.frame.origin.x, self.messageDetails.frame.origin.y, self.messageDetails.frame.size.width, height+6);
    self.sentDate.frame = CGRectMake(self.sentDate.frame.origin.x,self.chatBG.frame.size.height-self.sentDate.frame.size.height+10, self.sentDate.frame.size.width, self.sentDate.frame.size.height);
    
    self.messageDetails.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.sentDate.font = [UIFont fontWithName:@"Helvetica" size:10];
}

@end
