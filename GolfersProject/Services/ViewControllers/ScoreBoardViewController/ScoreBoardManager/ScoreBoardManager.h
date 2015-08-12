//
//  ScoreBoardManager.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/29/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreCard.h"


@interface ScoreBoardManager : NSObject

+ (ScoreBoardManager *)sharedScoreBoardManager;
@property(assign,nonatomic)int numberOfSections;
@property(assign,nonatomic)int numberOfItems;
@property(strong,nonatomic)NSMutableSet *defaultSymbolsSet;

@property(strong, nonatomic)ScoreCard *scoreCard;


@end
