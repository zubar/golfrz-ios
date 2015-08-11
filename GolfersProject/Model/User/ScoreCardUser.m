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
        
        /*
         {
         "tee_box" =     {
         color = ff0000;
         name = Blue;
         };
         user =     {
         "first_name" = inviter;
         handicap = 7;
         id = 25;
         "last_name" = test;
         };
         "user_id" = 25;
         }

         */

        NSDictionary *userDictionary = [[dictionary objectForKey:@"user"] isKindOfClass:[NSNull class]] ?nil :[dictionary objectForKey:@"user"];
        if (userDictionary) {
        
            _userId = [[userDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]] ?nil :[userDictionary objectForKey:@"id"];
            _firstName = [[userDictionary objectForKey:@"first_name"] isKindOfClass:[NSNull class]] ?nil :[userDictionary objectForKey:@"first_name"];
            _handiCap = [[userDictionary objectForKey:@"handicap"] isKindOfClass:[NSNull class]] ?nil :[userDictionary objectForKey:@"handicap"];
            
        }
        
        NSDictionary *teeBoxDict = [[dictionary objectForKey:@"tee_box"] isKindOfClass:[NSNull class]] ?nil :[dictionary objectForKey:@"tee_box"];
        _skinCount = [[dictionary objectForKey:@"skin_count"] isKindOfClass:[NSNull class]] ?nil :[dictionary objectForKey:@"skin_count"];
        _scoreCardTeeBox = [[ScoreCardTeeBox alloc] initWithDictionary:teeBoxDict];
        
    }
    return self;
}
@end
