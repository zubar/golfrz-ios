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

@implementation CalendarEventServices


+(void)getEvents:(void (^)(bool status, EventList * eventsArray))successBlock failure:(void (^)(bool status, NSError * error))failureBlock{

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

//TODO: update token code.

#pragma mark - Helper Methods

+(NSDictionary *)paramsForEventList{
    
    User * mUser = [UserServices currentUser];
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : @"h2_j_l-ZDOAAjCgVZ1zXHw"//[mUser authToken]
             };

}
@end
