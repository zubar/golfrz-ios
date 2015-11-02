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
#import "Teetime.h"
#import "UtilityServices.h"


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
            if(![UtilityServices checkIsUnAuthorizedError:error])
                failureBlock(false, [resp result]);
        }
    }];
}

+(void)bookTeeTimeSubcourse:(NSNumber *)subcourseId
                  playersNo:(NSNumber *)playerCount
                   bookTime:(NSDate *)bookTime
                    success:(void(^)(bool status, Teetime * teeTime))successBlock
                    failure:(void(^)(bool status, GolfrzError * error))failureBlock{
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    NSLog(@"BOOKTEE-TIME:%@", [TeetimeServices paramBookTeetime:subcourseId players:playerCount bookingTime:bookTime] );
    
    [apiClient POST:kBookTeetime parameters:[TeetimeServices paramBookTeetime:subcourseId players:playerCount bookingTime:bookTime] completion:^(id response, NSError *error) {
        if(error) {
            if(![UtilityServices checkIsUnAuthorizedError:error])
                failureBlock(false, [response result]);
        }
        else{
            NSDictionary * dataDict = [[response result] objectForKey:@"tee_time"];
            NSError * error = nil;
            Teetime * teeTime = [MTLJSONAdapter modelOfClass:[Teetime class] fromJSONDictionary:dataDict error:&error];
            successBlock(true, teeTime);
        }
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
       else{
           if(![UtilityServices checkIsUnAuthorizedError:error])
               failureBlock(false, [response result]);
       }
   }];
}

#pragma mark - HelperMethods

+(NSDictionary *)paramUpdateTeetime:(Teetime *)teeTime playerCount:(NSNumber *)playerCount{
    NSDictionary * param = @{
             @"count" : playerCount,
             @"sub_course_id" : [teeTime subCourseId],
             @"booked_time" : [[[teeTime bookedTime] toGlobalTime] serverFormatDate],
             @"tee_time_id" : [teeTime itemId],
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];

}

+(NSDictionary *)paramsGetTeetimesSubcourse:(NSNumber *)subcourseId startDate:(NSDate *)strtDate endDate:(NSDate *)endDate{
    
    
    NSDictionary * param = @{
             @"sub_course_id" : subcourseId,
             @"start_date" : [strtDate serverFormatDate],
             @"end_date" : [endDate serverFormatDate],
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
    
}

+(NSDictionary *)paramBookTeetime:(NSNumber *)subCourseId players:(NSNumber *)playersCount bookingTime:(NSDate *)bookingTime{
    
    NSDictionary * param = @{
             @"count" : playersCount,
             @"sub_course_id" : subCourseId,
             @"booked_time" : [bookingTime serverFormatDate],
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}


@end
