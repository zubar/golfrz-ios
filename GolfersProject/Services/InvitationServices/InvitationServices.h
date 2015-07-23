//
//  InvitationServices.h
//  GolfersProject
//
//  Created by Zubair on 7/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RoundInvitationType) {
    RoundInvitationTypeSMS = 0,
    RoundInvitationTypeEmail,
    RoundInvitationTypeInApp,
    RoundInvitationTypeFacebook,
};

@interface InvitationServices : NSObject


+(void)getInAppUsers:(void (^)(bool status, NSArray * inAppUsers))successBlock
             failure:(void (^)(bool status, NSError * error))failureBlock;

+(void)getInvitationTokenForInvitee:(NSArray *)invitees
                               type:(RoundInvitationType)smsEmail
                            success:(void (^)(bool status, NSString * invitationToken))successBlock
                            failure:(void (^)(bool status, NSError * error))failureBlock;

+(void)getInvitationDetail:(void (^)(bool status, id invitation))successBlock
                   failure:(void (^)(bool status, NSError * error))failureBlock;

+(NSString *)getinvitationAppOpenUrlForInvitation:(NSString *)appInvitationToken;

@end
