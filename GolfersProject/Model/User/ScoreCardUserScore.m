//
//  ScoreCardUserScore.m
//  GolfersProject
//
//  Created by Waqas Naseem on 8/5/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreCardUserScore.h"

@implementation ScoreCardUserScore

-(instancetype)initWithDictionary:(NSDictionary *)dic andKey:(NSString *)key
{
    if (self = [super init]) {
        
        /*
         27 =     {
         score = 4;
         symbol =         {
         "shot_type" = berdie;
         symbol = "circle, green_dot";
         };
         }
         */
        
//        NSString *key = [dic allKeys].firstObject;
        _userId = [NSNumber numberWithInt:[key intValue]];
        NSDictionary *holeData = dic;//[[dic objectForKey:key] isKindOfClass:[NSNull class]]?nil:[dic objectForKey:key];
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
    }
    return self;
}
@end
