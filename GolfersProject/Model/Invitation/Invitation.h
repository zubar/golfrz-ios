//
//  Invitation.h
//  GolfersProject
//
//  Created by Zubair on 8/31/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface Invitation :  MTLModel<MTLJSONSerializing>
@property (copy, nonatomic, readonly) NSString * message;
@property (copy, nonatomic, readonly) NSString * invitationToken;
@property (copy, nonatomic, readonly) NSString * iOSInvitationUrl;
@property (copy, nonatomic, readonly) NSString * androidInvitationUrl;
@end
