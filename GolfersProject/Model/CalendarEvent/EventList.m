//
//  EventsList.m
//  GolfersProject
//
//  Created by Zubair on 5/27/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "EventList.h"
#import "CalendarEvent.h"

@implementation EventList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"items" : @"events",
             //propertyName : json_key
             };
}


+ (NSValueTransformer *)itemsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CalendarEvent class]];
}

@end
