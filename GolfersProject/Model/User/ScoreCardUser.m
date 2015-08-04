//
//  ScoreCardUser.m
//  GolfersProject
//
//  Created by Waqas Naseem on 7/31/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreCardUser.h"

@implementation ScoreCardUser

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        /*"id": 25,
        "first_name": "inviter",
        "handicap": 7
         */
        _userId = [[dictionary objectForKey:@"id"] isKindOfClass:[NSNull class]] ?nil :[dictionary objectForKey:@"id"];
        _firstName = [[dictionary objectForKey:@"first_name"] isKindOfClass:[NSNull class]] ?nil :[dictionary objectForKey:@"first_name"];
        _handiCap = [[dictionary objectForKey:@"handicap"] isKindOfClass:[NSNull class]] ?nil :[dictionary objectForKey:@"handicap"];
        
    }
    return self;
}
@end
