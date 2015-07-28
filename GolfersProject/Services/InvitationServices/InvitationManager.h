//
//  InvitationManager.h
//  GolfersProject
//
//  Created by Zubair on 7/24/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitationManager : NSObject

+ (InvitationManager *)sharedInstance;

-(BOOL )isInvitationAccepted;
-(void)setInvitationStatusAccepted:(BOOL )waitingStatus;


-(NSString *)invitationToken;
-(void)setInvitationToken:(NSString *)token;
-(void)deleteInvitation;

@end
