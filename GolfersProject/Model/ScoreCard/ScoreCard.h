//
//  ScoreCard.h
//  GolfersProject
//
//  Created by Waqas Naseem on 7/31/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
@interface ScoreCard : NSObject

//start code 4 bug
@property(nonatomic,strong) NSString *scoreType;
//end code 4 bug

@property(nonatomic,strong)NSMutableArray *users;
@property(nonatomic,strong)NSNumber *teeBoxCount;
@property(nonatomic,strong)NSString *gameType;
@property(nonatomic)NSUInteger holeCount;
@property(nonatomic,strong)NSNumber *grossFirst;
@property(nonatomic,strong)NSMutableArray *holesArray;


-(instancetype)initWithDictionary:(NSDictionary *)data;
@end
