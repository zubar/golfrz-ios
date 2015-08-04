//
//  ScoreCardTeeBox.h
//  GolfersProject
//
//  Created by Waqas Naseem on 7/31/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreCardTeeBox : NSObject

@property(nonatomic,strong)NSNumber *handiCap;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *color;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
