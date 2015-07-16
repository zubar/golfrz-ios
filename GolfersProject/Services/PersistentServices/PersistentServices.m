//
//  PersistentServices.m
//  GolfersProject
//
//  Created by Zubair on 7/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PersistentServices.h"

#define fileName @"DataDict.dict"

@implementation PersistentServices

+ (PersistentServices *)sharedServices {
    
    static PersistentServices *sharedInstance = nil;
    
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[PersistentServices alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self isFileExists]) {
            dataDict = [[NSMutableDictionary alloc]initWithContentsOfFile:[self filePath]];
        }else{
            dataDict = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

-(NSString *)currentUserToken{
  return  dataDict[@"currentUserToken"];
}

-(void)setCurrentUserToken:(NSString *)userToken{
    [dataDict setObject:userToken forKey:@"currentUserToken"];
    [self writeDataToFile];
}


-(NSString *)currentUserEmail{
    return  dataDict[@"currentUserEmail"];
}

-(void)setCurrentUserEmail:(NSString *)email{
    [dataDict setObject:email forKey:@"currentUserEmail"];
    [self writeDataToFile];
}

-(NSNumber *)currentRoundId{
    return dataDict[@"currentRoundId"];
}

-(void)setCurrentRoundId:(NSNumber *)roundId{
    [dataDict setObject:roundId forKey:@"currentRoundId"];
    [self writeDataToFile];
}

-(NSNumber *)currentSubCourseId{
  return dataDict[@"currentSubCourseId"];
}

-(void)setCurrentSubCourseId:(NSNumber *)subCourseId{
    [dataDict setObject:subCourseId forKey:@"currentSubCourseId"];
}

-(NSNumber *)currentGameTypeId{
    return dataDict[@"gameTypeId"];
}

-(void)setCurrentGameTypeId:(NSNumber *)gameType{
    [dataDict setObject:gameType forKey:@"gameTypeId"];
    [self writeDataToFile];
}

-(NSNumber *)currentScoreTypeId{
    return dataDict[@"currentScoreTypeId"];
}

-(void)setCurrentScoreTypeId:(NSNumber *)curScoreType{
    [dataDict setObject:curScoreType forKey:@"currentScoreTypeId"];
    [self writeDataToFile];
}

-(NSNumber *)currentTeebox{
    return dataDict[@"currentTeebox"];
}

-(void)setcurrentTeebox:(NSNumber *)teebox{
    [dataDict setObject:teebox forKey:@"currentTeebox"];
    [self writeDataToFile];
}

//
-(NSString *)currentInvitationToken{
    return dataDict[@"currentInvitationToken"];
}

-(void)setCurrentInvitationToken:(NSString *)teebox{
    [dataDict setObject:teebox forKey:@"currentInvitationToken"];
    [self writeDataToFile];
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
