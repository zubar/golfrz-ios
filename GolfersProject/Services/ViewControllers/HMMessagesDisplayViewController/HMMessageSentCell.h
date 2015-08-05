//
//  HMDataCell.h
//  HomeWorkDiary
//
//  Created by Zubair on 04/08/2014.
//  Copyright (c) 2014 Tkxel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
@interface HMMessageSentCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *sentDate;
@property (strong, nonatomic) IBOutlet UIImageView * chatBG;
@property (strong, nonatomic) IBOutlet UILabel *messageDetails;

@property (weak,nonatomic) Comment * DTOObject;


@end
