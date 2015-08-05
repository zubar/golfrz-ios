//
//  ScoreCardHole.m
//  GolfersProject
//
//  Created by Waqas Naseem on 7/31/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreCardHole.h"
#import "ScoreCardUserScore.h"
#import "ScoreCardTeeBox.h"

@implementation ScoreCardHole

-(instancetype)initWithDictionary:(NSDictionary *)dictionary andTeeBoxCount:(NSNumber *)teeBoxCount
{
    if (self = [super init]) {
        
        /*"hole_1": {
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
         */
        
        
        NSString *holeKey = nil;
        _scoreUsers = [NSMutableArray new];
        NSMutableArray *tempArray = [NSMutableArray new];
        for (id key in [dictionary allKeys]) {
            
            NSNumber *keyNumber = [NSNumber numberWithInt:[key intValue]];
            if ([keyNumber intValue] > 0) {
                
                holeKey = key;
                //_userId = keyNumber;
                NSDictionary *userScoreDic = [dictionary objectForKey:holeKey];
                ScoreCardUserScore *userScore = [[ScoreCardUserScore alloc] initWithDictionary:userScoreDic andKey:holeKey];
                
                if (userScore) {
                    [tempArray addObject:userScore];
                }
            }
        }
        //sort score users array
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self.userId"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        _scoreUsers = [NSMutableArray arrayWithArray:[tempArray sortedArrayUsingDescriptors:sortDescriptors]];
        
        
//        NSDictionary *holeData = [[dictionary objectForKey:holeKey] isKindOfClass:[NSNull class]]?nil:[dictionary objectForKey:holeKey];
//        if (holeData) {
//            
//            NSString *scoreString = [[holeData objectForKey:@"score"] isKindOfClass:[NSNull class]]?nil: [holeData objectForKey:@"score"];
//            _score = [NSNumber numberWithInt:[scoreString intValue]];
//            NSDictionary *symbolData = [[holeData objectForKey:@"symbol"] isKindOfClass:[NSNull class]]?nil:[holeData objectForKey:@"symbol"];
//            if (symbolData) {
//                
//                _shotType = [[symbolData objectForKey:@"shot_type"] isKindOfClass:[NSNull class]]?nil: [symbolData objectForKey:@"shot_type"];
//                NSString *symbol = [[symbolData objectForKey:@"symbol"] isKindOfClass:[NSNull class]]?nil: [symbolData objectForKey:@"symbol"];
//                NSArray *symbolsArray = [symbol componentsSeparatedByString:@","];
//                if (symbolsArray && symbolsArray.count > 1) {
//                    _shape = symbolsArray.firstObject;
//                    _shapeColor = symbolsArray.lastObject;
//                }
//            }
//            
//            
//            
//        }
        _parValue = [[dictionary objectForKey:@"par_value"] isKindOfClass:[NSNull class]]?nil: [dictionary objectForKey:@"par_value"];
        _teeBoxArray = [NSMutableArray new];
        for (int i = 0; i<[teeBoxCount intValue]; i++) {
            
            NSString *teeBoxKey = [NSString stringWithFormat:@"tee_box_%d",i];
            NSDictionary *teeBox = [[dictionary objectForKey:teeBoxKey] isKindOfClass:[NSNull class]]?nil: [dictionary objectForKey:teeBoxKey];
            ScoreCardTeeBox *scoreTeeBox = [[ScoreCardTeeBox alloc] initWithDictionary:teeBox];
            [_teeBoxArray addObject:scoreTeeBox];
        }
        
        
        
    }
    return self;
}
@end

