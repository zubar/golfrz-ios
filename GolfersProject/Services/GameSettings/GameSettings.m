//
//  PersistentServices.m
//  GolfersProject
//
//  Created by Zubair on 7/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "GameSettings.h"
#import "AppDelegate.h"

#import "SubCourse.h"
#import "GameType.h"
#import "ScoreType.h"
#import "Teebox.h"

#define fileName @"game_settings.dict"

@implementation GameSettings

+ (GameSettings *)sharedSettings {
    
    static GameSettings *sharedInstance = nil;
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[GameSettings alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Observe notif to write all data to file before leaving the app.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppStateChangeNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        
//        if ([self isFileExists]) {
//            dataDict = [[NSMutableDictionary alloc]initWithContentsOfFile:[self filePath]];
//        }else
        {
            dataDict = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

//------------------------- RoundID ----------------------------------

-(NSNumber *)roundId{
    return dataDict[@"RoundId"];
}
-(void)setroundId:(NSNumber *)roundId{
    [dataDict setObject:roundId forKey:@"RoundId"];
}
//------------------------- SubCourse ID & Subcourse ------------------

-(NSNumber *)subCourseId{
  return dataDict[@"currentSubCourseId"];
}

-(void)setsubCourseId:(NSNumber *)subCourseId{
    [dataDict setObject:subCourseId forKey:@"currentSubCourseId"];
}

-(SubCourse *)subCourse{
    return dataDict[@"subCourse"];
}
-(void)setsubCourse:(SubCourse *)subCourse{
    [dataDict setObject:subCourse forKey:@"subCourse"];
}

//-------------------------------------------

-(NSNumber *)gameTypeId{
    return dataDict[@"gameTypeId"];
}

-(void)setgameTypeId:(NSNumber *)gameType{
    [dataDict setObject:gameType forKey:@"gameTypeId"];
}

-(GameType *)gameType{
    return dataDict[@"gameType"];
}
-(void)setgameType:(GameType *)gameType{
    [dataDict setObject:gameType forKey:@"gameType"];
}

//-------------------------------------------


-(NSNumber *)scoreTypeId{
    return dataDict[@"currentScoreTypeId"];
}
-(void)setscoreTypeId:(NSNumber *)curScoreType{
    [dataDict setObject:curScoreType forKey:@"currentScoreTypeId"];
}
-(ScoreType *)scoreType{
    return dataDict[@"scoreType"];
}
-(void)setscoreType:(ScoreType *)curScoreType{
    [dataDict setObject:curScoreType forKey:@"scoreType"];
}

//-------------------------------------------

-(NSNumber *)teeboxId{
    return dataDict[@"currentTeebox"];
}
-(void)setteeboxId:(NSNumber *)teebox{
    [dataDict setObject:teebox forKey:@"currentTeebox"];
}
-(Teebox *)teebox{
    return dataDict[@"teebox"];
}
-(void)setteebox:(Teebox *)teebox{
    [dataDict setObject:teebox forKey:@"teebox"];
}
//-------------------------------------------

-(NSNumber *)inviteeId{
    return dataDict[@"invitee"];
}

-(void)setInviteeId:(NSNumber *)invitee{
    [dataDict setObject:invitee forKey:@"invitee"];
}

-(BOOL )isInvitee{
    return [dataDict[@"isInvitee"] boolValue];
}
-(void)setInvitee:(BOOL )invitee{
    [dataDict setObject:[NSNumber numberWithBool:invitee] forKey:@"isInvitee"];
}
//-------------------------------------------

-(BOOL )isWaitingForPlayers{
    return [dataDict[@"isWaitingForPlayers"] boolValue];
}
-(void)setWaitingForPlayers:(BOOL )waitingStatus{
    [dataDict setObject:[NSNumber numberWithBool:waitingStatus] forKey:@"isWaitingForPlayers"];
}
//-------------------------------------------


-(BOOL )isRoundInProgress{
    return [dataDict[@"roundInProgress"] boolValue];
}

-(void)setIsRoundInProgress:(BOOL )roundstatus{
    [dataDict setObject:[NSNumber numberWithBool:roundstatus] forKey:@"roundInProgress"];
}

-(void)setTotalNumberOfHoles:(NSNumber *)holescount{
    [dataDict setObject:holescount forKey:@"holesCount"];
}

-(NSNumber *)totalNumberOfHoles{
    return [dataDict objectForKey:@"holesCount"];
}

//------------------------------ Invitation Related Stuff -------------------

-(NSString *)invitationToken{
    return dataDict[@"invitationToken"];
}

-(void)setInvitationToken:(NSString *)token{
    [dataDict setObject:token forKey:@"invitationToken"];
}
-(void)deleteInvitation{
    [dataDict removeObjectForKey:@"invitationToken"];
}

//----------------------------- Reset -----------------------------------------
-(void)resetGameSettings{
    [self deleteInvitation];
    [self setIsRoundInProgress:NO];
    [self setWaitingForPlayers:NO];
    [self setInvitee:NO];
    [self setroundId:(NSNumber *)[NSNull null]];
    [self setInviteeId:(NSNumber *)[NSNull null]];
    [self setteeboxId:(NSNumber *)[NSNull null]];
    [self setscoreTypeId:(NSNumber *)[NSNull null]];
    [self setscoreType:(ScoreType *)[NSNull null]];
    [self setgameType:(GameType *)[NSNull null]];
    [self setgameTypeId:(NSNumber *)[NSNull null]];
    [self setsubCourse:(SubCourse *)[NSNull null]];
    [self setsubCourseId:(NSNumber *)[NSNull null]];
}

#pragma mark - HandleAppStateChangeNotif

-(void)handleAppStateChangeNotification:(NSNotification *)notif{
    // Write data to file.
    if ([notif isEqual:UIApplicationWillResignActiveNotification]) {
        [self writeDataToFile];
    }
}


#pragma mark - Helpers Private

-(NSString *)filePath{
    return [NSString stringWithFormat:@"%@%@", [self applicationDocumentsDirectory], fileName];
}

-(NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(void)writeDataToFile{
    [dataDict writeToFile:[self filePath] atomically:YES];
}

-(BOOL)isFileExists{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self filePath]];
}
@end
