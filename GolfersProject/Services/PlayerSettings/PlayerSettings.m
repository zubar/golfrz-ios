//
//  PersistentServices.m
//  GolfersProject
//
//  Created by Zubair on 7/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PlayerSettings.h"
#import "AppDelegate.h"

#define fileName @"player_settings.dict"

@implementation PlayerSettings

+ (PlayerSettings *)sharedSettings {
    
    static PlayerSettings *sharedInstance = nil;
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[PlayerSettings alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppStateChangeNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        if ([self isFileExists]) {
            dataDict = [[NSMutableDictionary alloc]initWithContentsOfFile:[self filePath]];
        }else{
            dataDict = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

-(NSString *)userToken{
  return  dataDict[@"UserToken"];
}

-(void)setuserToken:(NSString *)userToken{
    [dataDict setObject:userToken forKey:@"UserToken"];
}


-(NSString *)userEmail{
    return  dataDict[@"UserEmail"];
}

-(void)setuserEmail:(NSString *)email{
    [dataDict setObject:email forKey:@"UserEmail"];
}

-(NSNumber *)userId{
    return  dataDict[@"userId"];
}

-(void)setUserId:(NSNumber *)userId{
    [dataDict setObject:userId forKey:@"userId"];
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
