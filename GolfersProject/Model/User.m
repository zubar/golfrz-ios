//
//  User.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/29/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "User.h"

@implementation User


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"memberId" : @"member_id",
             @"email" : @"email",
             @"firstName": @"first_name",
             @"lastName" : @"last_name",
             @"handicap" : @"handicap"
             //propertyName : json_key
             };
}
@end
