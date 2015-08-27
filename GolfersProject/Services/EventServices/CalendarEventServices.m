//
//  CalendarEventServices.m
//  GolfersProject
//
//  Created by Zubair on 5/26/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "CalendarEventServices.h"
#import "APIClient.h"
#import "Constants.h"
#import "UserServices.h"
#import "User.h"
#import "EventList.h"
#import "UtilityServices.h"

@implementation CalendarEventServices


+(void)getEvents:(void (^)(bool status, EventList * eventsArray))successBlock
         failure:(void (^)(bool status, NSError * error))failureBlock
{

    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kCalenderEventsList parameters:[CalendarEventServices paramsForEventList] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            EventList * mlist = [resp result];
            successBlock(true, mlist);
        }else
            failureBlock(false, error);
    }];
}

#pragma mark - Helper Methods

+(NSDictionary *)paramsForEventList
{
    return [UtilityServices authenticationParams];
}
@end
