//
//  InvitationServices.h
//  GolfersProject
//
//  Created by Zubair on 7/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GolfrzError.h"
@class Invitation;

typedef NS_ENUM(NSInteger, RoundInvitationType) {
    RoundInvitationTypeSMS = 0,
    RoundInvitationTypeEmail,
    RoundInvitationTypeInApp,
    RoundInvitationTypeFacebook,
};

@interface InvitationServices : NSObject


+(void)getInAppUsers:(void (^)(bool status, NSArray * inAppUsers))successBlock
             failure:(void (^)(bool status, GolfrzError * error))failureBlock;


+(void)getInvitationTokenForInvitee:(NSArray *)invitees
                               type:(RoundInvitationType)smsEmail
                            success:(void (^)(bool status, Invitation * curInvitation ))successBlock
                            failure:(void (^)(bool status, GolfrzError * error))failureBlock;


+(void)getInvitationDetail:(void (^)(bool status, id roundId))successBlock
                   failure:(void (^)(bool status, GolfrzError * error))failureBlock;

//+(NSString *)getinvitationAppOpenUrlForInvitation:(NSString *)appInvitationToken;

@end
