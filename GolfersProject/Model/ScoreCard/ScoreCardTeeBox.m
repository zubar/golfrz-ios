//
//  ScoreCardTeeBox.m
//  GolfersProject
//
//  Created by Waqas Naseem on 7/31/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreCardTeeBox.h"

@implementation ScoreCardTeeBox

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        _handiCap = [[dictionary objectForKey:@"handicap"] isKindOfClass:[NSNull class]]?nil:[dictionary objectForKey:@"handicap"];
        _name = [[dictionary objectForKey:@"name"] isKindOfClass:[NSNull class]]?nil:[dictionary objectForKey:@"name"];
        _color = [[dictionary objectForKey:@"color"] isKindOfClass:[NSNull class]]?nil:[dictionary objectForKey:@"color"];
        
        
    }
    return self;
}
@end
