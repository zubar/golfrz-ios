//
//  SharedManager.m
//  GolfersProject
//
//  Created by Zubair on 6/1/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "SharedManager.h"

@implementation SharedManager


+ (SharedManager *)sharedInstance {
    
    static SharedManager *sharedInstance = nil;

    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[SharedManager alloc] init];
    });
    
    return sharedInstance;
}



@end
