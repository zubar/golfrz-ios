//
//  TeetimeServices.h
//  GolfersProject
//
//  Created by Zubair on 7/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TeetimeData;
@class GolfrzError;
@class Teetime;

@interface TeetimeServices : NSObject

+(void)getTeetimesForSubcourse:(NSNumber *)subcourseId
                     startDate:(NSDate *)startDate
                       endDate:(NSDate *)endDate
                       success:(void(^)(bool status, TeetimeData * dataTees ))successBlock
                       failure:(void (^)(bool status, GolfrzError * error))failureBlock;


+(void)bookTeeTimeSubcourse:(NSNumber *)subcourseId
                  playersNo:(NSNumber *)playerCount
                   bookTime:(NSDate *)bookTime
                    success:(void(^)(bool status, Teetime * teeTime))successBlock
                    failure:(void(^)(bool status, GolfrzError * error))failureBlock;

+(void)updateTeeTime:(Teetime *)teetime
         playerCount:(NSNumber *)playerCount
             success:(void(^)(bool status, id response))successBlock
             failure:(void(^)(bool status, GolfrzError * error))failureBlock;

@end
