//
//  ScoreCardHole.m
//  GolfersProject
//
//  Created by Waqas Naseem on 7/31/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreCardHole.h"
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
        for (id key in [dictionary allKeys]) {
            
            NSNumber *keyNumber = [NSNumber numberWithInt:[key intValue]];
            if ([keyNumber intValue] > 0) {
                
                holeKey = key;
                _userId = keyNumber;
                break;
            }
        }
        NSDictionary *holeData = [[dictionary objectForKey:holeKey] isKindOfClass:[NSNull class]]?nil:[dictionary objectForKey:holeKey];
        if (holeData) {
            
            NSString *scoreString = [[holeData objectForKey:@"score"] isKindOfClass:[NSNull class]]?nil: [holeData objectForKey:@"score"];
            _score = [NSNumber numberWithInt:[scoreString intValue]];
            NSDictionary *symbolData = [[holeData objectForKey:@"symbol"] isKindOfClass:[NSNull class]]?nil:[holeData objectForKey:@"symbol"];
            if (symbolData) {
                
                _shotType = [[symbolData objectForKey:@"shot_type"] isKindOfClass:[NSNull class]]?nil: [symbolData objectForKey:@"shot_type"];
                NSString *symbol = [[symbolData objectForKey:@"symbol"] isKindOfClass:[NSNull class]]?nil: [symbolData objectForKey:@"symbol"];
                NSArray *symbolsArray = [symbol componentsSeparatedByString:@","];
                if (symbolsArray && symbolsArray.count > 1) {
                    _shape = symbolsArray.firstObject;
                    _shapeColor = symbolsArray.lastObject;
                }
            }
            
            
            
        }
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

