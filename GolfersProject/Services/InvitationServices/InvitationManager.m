//
//  InvitationManager.m
//  GolfersProject
//
//  Created by Zubair on 7/24/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "InvitationManager.h"

@implementation InvitationManager{
    
    NSMutableDictionary * dataDict;
}

+ (InvitationManager *)sharedInstance {
    
    static InvitationManager *sharedInstance = nil;
    
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[InvitationManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dataDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}


#pragma mark - Manage Invitation
-(BOOL )isInvitationAccepted{
    return [dataDict[@"invitationStatus"] boolValue];
}

-(void)setInvitationStatusAccepted:(BOOL )waitingStatus{
    [dataDict setObject:[NSNumber numberWithBool:waitingStatus] forKey:@"invitationStatus"];
}

-(NSString *)invitationToken{
    return dataDict[@"invitationToken"];
}

-(void)setInvitationToken:(NSString *)token{
    [dataDict setObject:token forKey:@"invitationToken"];
}
-(void)deleteInvitation{
    [dataDict removeObjectForKey:@"invitationToken"];
}

@end
