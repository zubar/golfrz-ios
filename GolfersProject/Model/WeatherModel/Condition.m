//
//  Condition.m
//  GolfersProject
//
//  Created by Zubair on 5/21/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "Condition.h"

@implementation Condition


+(Condition *)initWithDictionary:(NSDictionary *)dataDict{

    Condition * conditionObject = [[Condition alloc]init];
    conditionObject.main = dataDict[@"main"];
    conditionObject.breif = dataDict[@"description"];
    conditionObject.icon = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",dataDict[@"icon"]];

    return conditionObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
      //  <#statements#>
    }
    return self;
}


@end
