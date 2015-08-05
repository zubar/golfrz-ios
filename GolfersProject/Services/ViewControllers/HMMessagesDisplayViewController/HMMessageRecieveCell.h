//
//  HMDataCell.h
//  HomeWorkDiary
//
//  Created by Zubair on 04/08/2014.
//  Copyright (c) 2014 Tkxel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface HMMessageRecieveCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *recieveDate;
@property (strong, nonatomic) IBOutlet UIImageView * chatBG;
@property (strong, nonatomic) IBOutlet UILabel *messageDetails;
@property (weak,nonatomic) Comment * DTOObject;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;

@property (weak, nonatomic) IBOutlet UIImageView *imgUser;

@end
