//
//  TeetimeServices.m
//  GolfersProject
//
//  Created by Zubair on 7/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "TeetimeServices.h"
#import "Constants.h"
#import "UserServices.h"
#import "SubCourse.h"
#import "GameSettings.h"
#import "APIClient.h"
#import "GolfrzError.h"
#import "Utilities.h"
#import <Overcoat/Overcoat.h>
#import "TeetimeData.h"
#import "Teetime.h"
#import "NSDate+Helper.h"
#import "GolfrzError.h"



@implementation TeetimeServices

+(void)getTeetimesForSubcourse:(NSNumber *)subcourseId
                     startDate:(NSDate *)startDate
                       endDate:(NSDate *)endDate
                       success:(void(^)(bool status, TeetimeData * dataTees ))successBlock
                       failure:(void (^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    NSLog(@"GET-TEE-TIME: %@", [TeetimeServices paramsGetTeetimesSubcourse:subcourseId
                                                                 startDate:startDate
                                                                   endDate:endDate]);
    
    [apiClient GET:kGetteetimes parameters:[TeetimeServices paramsGetTeetimesSubcourse:subcourseId
                                                                             startDate:startDate
                                                                               endDate:endDate]
    completion:^(id response, NSError *error)
    {
        OVCResponse * resp = response;
        if (!error) {
            successBlock(true, [resp result]);
        }else{
            failureBlock(false, [resp result]);
        }
    }];
}

+(void)bookTeeTimeSubcourse:(NSNumber *)subcourseId
                  playersNo:(NSNumber *)playerCount
                   bookTime:(NSDate *)bookTime
                    success:(void(^)(bool status, id response))successBlock
                    failure:(void(^)(bool status, GolfrzError * error))failureBlock{
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient POST:kBookTeetime parameters:[TeetimeServices paramBookTeetime:subcourseId players:playerCount bookingTime:bookTime] completion:^(id response, NSError *error) {
        if(error) failureBlock(false, [response result]);
        else successBlock(true, [response result]);
    }];
}

+(void)updateTeeTime:(Teetime *)teetime
         playerCount:(NSNumber *)playerCount
             success:(void(^)(bool status, id response))successBlock
             failure:(void(^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
   [apiClient POST:kUpdateTeetime parameters:[TeetimeServices paramUpdateTeetime:teetime playerCount:playerCount] completion:^(id response, NSError *error) {
       if(!error) successBlock(true, [response result]);
       else failureBlock(false, [response result]);
   }];
}

#pragma mark - HelperMethods

+(NSDictionary *)paramUpdateTeetime:(Teetime *)teeTime playerCount:(NSNumber *)playerCount{
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"count" : playerCount,
             @"sub_course_id" : [teeTime subCourseId],
             @"booked_time" : [[[teeTime bookedTime] toGlobalTime] serverFormatDate],
             @"tee_time_id" : [teeTime itemId],
             };

}

+(NSDictionary *)paramsGetTeetimesSubcourse:(NSNumber *)subcourseId startDate:(NSDate *)strtDate endDate:(NSDate *)endDate{
    
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"sub_course_id" : subcourseId,
             @"start_date" : [[strtDate toGlobalTime] serverFormatDate],
             @"end_date" : [[endDate toGlobalTime] serverFormatDate],
             };
    
}

+(NSDictionary *)paramBookTeetime:(NSNumber *)subCourseId players:(NSNumber *)playersCount bookingTime:(NSDate *)bookingTime{
    
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"count" : playersCount,
             @"sub_course_id" : subCourseId,
             @"booked_time" : bookingTime,
             };
}


@end
