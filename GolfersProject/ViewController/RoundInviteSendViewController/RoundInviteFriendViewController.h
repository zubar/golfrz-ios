//
//  RoundInviteSendViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/3/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ContactCell.h"
#import "BaseViewController.h"

typedef  NS_ENUM(NSUInteger, FriendContactType){
    FriendContactTypeAddressbookSMS = 0,
    FriendContactTypeAddressbookEmail,
    FriendContactTypeFacebookEmail,
    FriendContactTypeInAppUser,
    FriendContactTypeGuest,
};

@interface RoundInviteFriendViewController : BaseViewController<UITableViewDataSource,
                                                            UITableViewDelegate,
                                                            MFMessageComposeViewControllerDelegate,
                                                            MFMailComposeViewControllerDelegate,
                                                            ContactCellDelegate>{
}
@property (nonatomic, assign) FriendContactType currentFriendContactType;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

@end
