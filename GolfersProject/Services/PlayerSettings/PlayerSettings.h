//
//  PersistentServices.h
//  GolfersProject
//
//  Created by Zubair on 7/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlayerSettings : NSObject{
    NSMutableDictionary * dataDict;
}

+(PlayerSettings *)sharedSettings;

-(NSString *)userToken;
-(void)setuserToken:(NSString *)userToken;

-(NSString *)userEmail;
-(void)setuserEmail:(NSString *)email;

-(NSNumber *)userId;
-(void)setUserId:(NSNumber *)userId;

@end
