//
//  Invitation.m
//  GolfersProject
//
//  Created by Zubair on 8/31/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Invitation.h"

@implementation Invitation

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"message" : @"success_message",
             @"invitationToken" : @"invitation_token",
             @"iOSInvitationUrl" : @"url_ios",
             @"androidInvitationUrl" : @"url_android",
             };
}
@end
