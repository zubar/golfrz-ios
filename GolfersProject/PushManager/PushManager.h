//
//  PushManager.h
//  GolfersProject
//
//  Created by Zubair on 6/8/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PushManager : NSObject

+ (PushManager *)sharedInstance;

@property (assign, nonatomic) BOOL isRegisteredForPush;
@property (strong, nonatomic) NSString * pushToken;

-(void)registerForPushMessages;
-(void)addNotificationToList:(NSDictionary *)object;
-(void)postTokenToServer;


@end
