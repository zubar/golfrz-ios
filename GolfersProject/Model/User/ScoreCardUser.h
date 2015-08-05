//
//  ScoreCardUser.h
//  GolfersProject
//
//  Created by Waqas Naseem on 7/31/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreCardTeeBox.h"
@interface ScoreCardUser : NSObject

@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSNumber *handiCap;
@property(nonatomic,assign)int grossFirst;
@property(nonatomic,assign)int grossLast;
@property(nonatomic,strong)NSString *firstName;
@property(nonatomic,strong)ScoreCardTeeBox *scoreCardTeeBox;

-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
