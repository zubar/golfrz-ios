//
//  HMDataCell.m
//  HomeWorkDiary
//
//  Created by Zubair on 04/08/2014.
//  Copyright (c) 2014 Tkxel. All rights reserved.
//

#import "HMMessageRecieveCell.h"
#import "Utility.h"

@implementation HMMessageRecieveCell
@synthesize recieveDate, messageDetails;
@synthesize DTOObject= _DTOObject;

-(void)setDTOObject:(DTOMessage *)DTOObject
{
    _DTOObject = DTOObject;
    self.recieveDate.text = [Utility convertDate:_DTOObject.dateTime InFormat:@"hh:mm a"];
    self.messageDetails.text = _DTOObject.text;
    
    //font setting + auto height adjustment
    int height = [Utility heightRequiredToShowText:_DTOObject.text forFont:[UIFont fontWithName:@"GothamBook" size:16] inWidth:218];
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,height+82-25);
    self.chatBG.frame = CGRectMake(self.chatBG.frame.origin.x, self.chatBG.frame.origin.y, self.chatBG.frame.size.width , self.frame.size.height-20);
    self.messageDetails.frame = CGRectMake(self.messageDetails.frame.origin.x, self.messageDetails.frame.origin.y, self.messageDetails.frame.size.width, height+6);
    self.recieveDate.frame = CGRectMake(self.recieveDate.frame.origin.x,self.chatBG.frame.size.height-self.recieveDate.frame.size.height+10, self.recieveDate.frame.size.width, self.recieveDate.frame.size.height);
    
    self.messageDetails.font = [UIFont fontWithName:@"GothamBook" size:14];
    self.recieveDate.font = [UIFont fontWithName:@"GothamBook" size:10];
}


@end
