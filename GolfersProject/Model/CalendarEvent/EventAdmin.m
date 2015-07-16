//
//  EventAdmin.m
//  GolfersProject
//
//  Created by Zubair on 6/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "EventAdmin.h"

@implementation EventAdmin


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"adminId" : @"id",
             @"email" : @"email",
             @"firstName" : @"first_name",
             @"lastName" : @"last_name",
             @"userName" : @"username",
             @"memberId" : @"member_id",
             @"handicap" : @"handicap",
             @"phoneNo" : @"phone_no",
             @"designation" : @"course_role",
             //propertyName : json_key
             };
}

@end
