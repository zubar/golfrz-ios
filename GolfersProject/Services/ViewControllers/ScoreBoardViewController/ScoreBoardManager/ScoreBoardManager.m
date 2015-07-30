//
//  ScoreBoardManager.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/29/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreBoardManager.h"

@implementation ScoreBoardManager

+ (ScoreBoardManager *)sharedScoreBoardManager {
    
    static ScoreBoardManager *sharedScoreBoardManager = nil;
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedScoreBoardManager = [[ScoreBoardManager alloc] init];
    });
    
    return sharedScoreBoardManager;
}

@end
