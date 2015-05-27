//
//  CalendarEventServices.h
//  GolfersProject
//
//  Created by Zubair on 5/26/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EventList;

@interface CalendarEventServices : NSObject
+(void)getEvents:(void (^)(bool status, EventList * eventsArray))successBlock failure:(void (^)(bool status, NSError * error))failureBlock;

@end
