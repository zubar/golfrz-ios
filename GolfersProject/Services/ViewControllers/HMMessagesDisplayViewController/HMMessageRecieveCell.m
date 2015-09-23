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
#import "UserServices.h"
#import "User+convenience.h"
#import "NSDate+Helper.h"

@implementation HMMessageRecieveCell
@synthesize recieveDate, messageDetails;
@synthesize DTOObject= _DTOObject;

-(void)setDTOObject:(Comment *)DTOObject
{
    _DTOObject = DTOObject;
    
    [Utilities dateComponentsFromNSDate:[[_DTOObject createdAt] toLocalTime]   components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString *timeAndMinute) {
        [self.recieveDate setText:timeAndMinute];
    }];
    self.messageDetails.text = _DTOObject.comment;
   
    [self.imgUser sd_setImageWithURL:[NSURL URLWithString:[_DTOObject.user imgPath]] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgUser setRoundedImage:image];
        }
        
    }];
    User * mUser = _DTOObject.user;
    //This is a wonderful chapi, don't try to torture your brain in resolving this... Its ISO certified.
    NSLog(@"currentUser:%@", mUser);
    if (!mUser) {
        self.lblUserName.text = [UserServices currentUserName];
    }else{
        self.lblUserName.text = mUser.firstName;
    }
}


@end
