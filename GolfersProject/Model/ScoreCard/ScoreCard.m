//
//  ScoreCard.m
//  GolfersProject
//
//  Created by Waqas Naseem on 7/31/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreCard.h"
#import "ScoreCardHole.h"
#import "ScoreCardUser.h"
@implementation ScoreCard

/*
 {
 "score_card": {
 "users": [
 {
 "id": 25,
 "first_name": "inviter",
 "handicap": 7
 }
 ],
 "tee_box_count": 1,
 "holes_data": {
 "hole_1": {
 "25": {
 "score": -1,
 "symbol": {
 "shot_type": "berdie",
 "symbol": "circle, green_dot"
 }
 },
 "par_value": 5,
 "tee_box_0": {
 "handicap": 3
 }
 },
 "hole_3": {
 "25": {
 "score": -1,
 "symbol": {
 "shot_type": "berdie",
 "symbol": "circle, green_dot"
 }
 },
 "par_value": 7,
 "tee_box_0": {
 "handicap": 3
 }
 },
 "hole_2": {
 "25": {
 "score": -1,
 "symbol": {
 "shot_type": "berdie",
 "symbol": "circle, green_dot"
 }
 },
 "par_value": 1,
 "tee_box_0": {
 "handicap": 5
 }
 }
 },
 "25_gross_first": -3
 }
 }
 */
-(instancetype)initWithDictionary:(NSDictionary *)data
{
    if (self = [super init]) {
        
        NSDictionary *scoreCard = [data objectForKey:@"score_card"];
        if (scoreCard) {
            
            NSArray *users = [scoreCard objectForKey:@"users"];
            if (users.count > 0) {
                _users = [NSMutableArray new];
                for (NSDictionary *user in users) {
                    
                    ScoreCardUser *scoreCardUser = [[ScoreCardUser alloc] initWithDictionary:user];
                    [_users addObject:scoreCardUser];
                }
            }
            _teeBoxCount = [[scoreCard objectForKey:@"tee_box_count"] isKindOfClass:[NSNull class]]?nil:[scoreCard objectForKey:@"tee_box_count"];
            
            NSDictionary *holesData = [[scoreCard objectForKey:@"holes_data"] isKindOfClass:[NSNull class]]?nil:[scoreCard objectForKey:@"holes_data"];
            _holeCount = holesData.count;
            _holesArray = [NSMutableArray new];
            for (NSString *holeKey in holesData.allKeys) {
                
                NSDictionary *holeDic = [holesData objectForKey:holeKey];
                
                ScoreCardHole *scoreCardHole = [[ScoreCardHole alloc] initWithDictionary:holeDic andTeeBoxCount:_teeBoxCount];
                NSArray *holeNumberSplit = [holeKey componentsSeparatedByString:@"_"];
                NSString *holeNumberString = holeNumberSplit.lastObject;
                scoreCardHole.holeNumber = [NSNumber numberWithInt:[holeNumberString intValue]];
                [_holesArray addObject:scoreCardHole];
            }
//            for (NSDictionary *hole in holesData.allValues) {
//                
//                ScoreCardHole *scoreCardHole = [[ScoreCardHole alloc] initWithDictionary:hole andTeeBoxCount:_teeBoxCount];
//                [_holesArray addObject:scoreCardHole];
//            }
            
        }
    }
    return self;
}

@end
