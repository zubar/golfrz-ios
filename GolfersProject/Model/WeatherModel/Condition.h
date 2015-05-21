//
//  Condition.h
//  GolfersProject
//
//  Created by Zubair on 5/21/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@interface Condition : NSObject//MTLModel<MTLJSONSerializing>


@property (retain, nonatomic ) NSString * main;   //main
@property (retain, nonatomic ) NSString * breif;
@property (retain, nonatomic ) NSString * icon;

+(Condition *)initWithDictionary:(NSDictionary *)dataDict;

@end
