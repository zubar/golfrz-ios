//
//  PersistentServices.h
//  GolfersProject
//
//  Created by Zubair on 7/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SubCourse;
@class GameType;
@class ScoreType;
@class Teebox;


@interface GameSettings : NSObject{
    NSMutableDictionary * dataDict;
}

+(GameSettings *)sharedSettings;


-(NSNumber *)roundId;
-(void)setroundId:(NSNumber *)roundId;

-(NSNumber *)subCourseId;
-(void)setsubCourseId:(NSNumber *)subCourseId;
-(SubCourse *)subCourse;
-(void)setsubCourse:(SubCourse *)subCourse;


-(NSNumber *)gameTypeId;
-(void)setgameTypeId:(NSNumber *)gameType;
-(GameType *)gameType;
-(void)setgameType:(GameType *)gameType;


-(NSNumber *)scoreTypeId;
-(void)setscoreTypeId:(NSNumber *)curScoreType;
-(ScoreType *)scoreType;
-(void)setscoreType:(ScoreType *)curScoreType;

-(NSNumber *)teeboxId;
-(void)setteeboxId:(NSNumber *)teeboxId;
-(Teebox *)teebox;
-(void)setteebox:(Teebox *)teebox;


-(NSNumber *)inviteeId;
-(void)setInviteeId:(NSNumber *)invitee;

-(BOOL )isWaitingForPlayers;
-(void)setWaitingForPlayers:(BOOL )waitingStatus;

-(BOOL )isInvitee;
-(void)setInvitee:(BOOL )waitingStatus;

-(BOOL )isRoundInProgress;
-(void)setIsRoundInProgress:(BOOL )roundstatus;

-(void)setTotalNumberOfHoles:(NSNumber *)holescount;
-(NSNumber *)totalNumberOfHoles;



-(NSString *)invitationToken;
-(void)setInvitationToken:(NSString *)token;
-(void)deleteInvitation;
@end
