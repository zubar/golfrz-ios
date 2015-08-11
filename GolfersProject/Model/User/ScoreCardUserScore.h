//
//  ScoreCardUserScore.h
//  GolfersProject
//
//  Created by Waqas Naseem on 8/5/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreCardUserScore : NSObject


@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSNumber *score;
@property(nonatomic,strong)NSString *shotType;
@property(nonatomic,strong)NSString *shape;
@property(nonatomic,strong)NSString *shapeColor;

-(instancetype)initWithDictionary:(NSDictionary *)dic andKey:(NSString *)key;
@end
