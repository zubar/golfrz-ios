//
//  ScoreCardUser.h
//  GolfersProject
//
//  Created by Waqas Naseem on 7/31/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreCardUser : NSObject

@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSNumber *handiCap;
@property(nonatomic,strong)NSString *firstName;

-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
