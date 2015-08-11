//
//  ScoreCardHole.h
//  GolfersProject
//
//  Created by Waqas Naseem on 7/31/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreCardHole : NSObject
/*
 
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
 */
@property(nonatomic,strong)NSNumber *holeNumber;
@property(nonatomic,strong)NSMutableArray *scoreUsers;
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSNumber *score;
@property(nonatomic,strong)NSString *shotType;
@property(nonatomic,strong)NSString *shape;
@property(nonatomic,strong)NSString *shapeColor;
@property(nonatomic,strong)NSNumber *parValue;
@property(nonatomic,strong)NSMutableArray *teeBoxArray;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary andTeeBoxCount:(NSNumber *)teeBoxCount;
@end
