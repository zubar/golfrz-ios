//
//  PersistentServices.h
//  GolfersProject
//
//  Created by Zubair on 7/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PersistentServices : NSObject{
    NSMutableDictionary * dataDict;
}

+(PersistentServices *)sharedServices;

-(NSString *)currentUserToken;
-(void)setCurrentUserToken:(NSString *)userToken;

-(NSString *)currentUserEmail;
-(void)setCurrentUserEmail:(NSString *)email;

-(NSNumber *)currentRoundId;
-(void)setCurrentRoundId:(NSNumber *)roundId;

-(NSNumber *)currentSubCourseId;
-(void)setCurrentSubCourseId:(NSNumber *)subCourseId;

-(NSNumber *)currentGameTypeId;
-(void)setCurrentGameTypeId:(NSNumber *)gameType;

-(NSNumber *)currentScoreTypeId;
-(void)setCurrentScoreTypeId:(NSNumber *)curScoreType;

-(NSNumber *)currentTeebox;
-(void)setcurrentTeebox:(NSNumber *)teebox;


-(NSString *)invitationToken;
-(void)setInvitationToken:(NSString *)teebox;


-(NSNumber *)invitee;
-(void)setInvitee:(NSNumber *)invitee;


-(BOOL )isWaitingForPlayers;
-(void)setWaitingForPlayers:(BOOL )waitingStatus;

-(BOOL )isRoundInProgress;
-(void)setIsRoundInProgress:(BOOL )roundstatus;
@end
