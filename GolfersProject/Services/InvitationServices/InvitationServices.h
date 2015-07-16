//
//  InvitationServices.h
//  GolfersProject
//
//  Created by Zubair on 7/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitationServices : NSObject

+(void)getInAppUsers:(void (^)(bool status, NSArray * inAppUsers))successBlock
             failure:(void (^)(bool status, NSError * error))failureBlock;

+(void)getInvitationToken:(void (^)(bool status, NSString * invitationToken))successBlock
                  failure:(void (^)(bool status, NSError * error))failureBlock;

+(void)getInvitationDetail:(void (^)(bool status, NSString * invitationToken))successBlock
                   failure:(void (^)(bool status, NSError * error))failureBlock;
@end
