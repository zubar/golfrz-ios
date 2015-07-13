//
//  RoundDataServices.m
//  GolfersProject
//
//  Created by Zubair on 7/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RoundDataServices.h"
#import "APIClient.h"
#import "Constants.h"
#import "UtilityServices.h"
#import "SharedManager.h"
#import "Constants.h"
#import "UserServices.h"
#import "AddPlayersViewController.h"
#import "PersistentServices.h"

@implementation RoundDataServices


+(void)getRoundData:(void (^)(bool status, RoundData * subCourse))successBlock
            failure:(void (^)(bool status, NSError * error))failureBlock{

    APIClient * apiClient = [APIClient sharedAPICLient];
    
    [apiClient GET:kRoundInSubCourse parameters:[UtilityServices authenticationParams] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            RoundData * mRoundData = [resp result];
            successBlock(true, mRoundData);
        }else
            failureBlock(false, error);
    }];
}


+(void)getNewRoundIdWithOptions:(NSDictionary *)options
                        success:(void (^)(bool status, NSNumber * roundId))successBlock
                        failure:(void (^)(bool status, NSError * error))failureBlock{
    
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    NSString * endPoint = kRoundNew;

    [apiClient POST:endPoint parameters:[RoundDataServices paramsCreateNewCourse:options] success:^(NSURLSessionDataTask *task, id responseObject) {
        
            NSUInteger  tRoundId = [[responseObject valueForKeyPath:@"round.id"] integerValue];
            NSNumber *  roundId = [NSNumber numberWithInteger:tRoundId];
            [[PersistentServices sharedServices] setCurrentRoundId:roundId];
            successBlock(true, roundId);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
    
}

+(void)startNewRoundWithOptions:(NSDictionary *)roundOptions
                        success:(void (^)(bool status, id roundId))successBlock
                        failure:(void (^)(bool status, NSError * error))failureBlock{
    
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    [apiClient POST:kRoundStart parameters:[RoundDataServices paramsCreateNewCourse:roundOptions] success:^(NSURLSessionDataTask *task, id responseObject) {
            successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
    
}

+(void)finishRoundWithBlock:(void(^)(bool status, id response))successBlock
                    failure:(void(^)(bool status, NSError * error))failureBlock{
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@", kBaseURL, kRoundFinish];
    
    [UtilityServices postData:[RoundDataServices paramsFinishRound]
                        toURL:urlString
                      success:^(bool status, NSDictionary *userInfo){
        successBlock(status, userInfo);
    } failure:^(bool status, NSError *error) {
        failureBlock(status, error);
    }];

}

+(void)addGuestWithEmail:(NSString *)email
               firstName:(NSString *)fName
                lastName:(NSString *)lName
                success:(void(^)(bool status, NSDictionary * response))successBlock
                failure:(void(^)(bool status, NSError * error))failureBlock{
                
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
                    
    [apiClient POST:kRoundAddGuest parameters:[RoundDataServices paramAddGuestToRoundEmail:email firstName:fName lastName:lName] success:^(NSURLSessionDataTask *task, id responseObject) {
            successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failureBlock(false, error);
    }];
                    
}

+(void)addShotRoundId:(NSNumber *)round
                holeId:(NSNumber *)holeId
              shotType:(NSString *)shotType
               success:(void(^)(bool, id))successBlock
               failure:(void(^)(bool, id))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kRoundAddGuest parameters:[RoundDataServices paramsPlayShotHoleId:holeId
                                                                              roundId:round
                                                                                 type:shotType]
            success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
}


+(void)deleteShotWithShotId:(NSNumber *)shotId
                 success:(void(^)(bool, id))successBlock
                 failure:(void(^)(bool, id))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kRoundAddGuest parameters:[RoundDataServices paramsDeleteShotId:shotId]
            success:^(NSURLSessionDataTask *task, id responseObject) {
                successBlock(true, responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                failureBlock(false, error);
            }];
}

+(void)deleteShotRoundId:(NSNumber *)round
                holeId:(NSNumber *)holeId
              shotType:(NSString *)shotType
                shotId:(NSNumber *)shotId
               success:(void(^)(bool, id))successBlock
               failure:(void(^)(bool, id))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kRoundAddGuest parameters:[RoundDataServices
                                               paramsDeleteShotHoleId:holeId
                                               roundId:round
                                               type:shotType
                                               shotId:shotId]
            success:^(NSURLSessionDataTask *task, id responseObject) {
                successBlock(true, responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                failureBlock(false, error);
            }];
    
}

+(void)addDirectScore:(NSNumber *)score
               holeId:(NSNumber *)holeId
              success:(void(^)(bool status, NSDictionary * response))successBlock
              failure:(void(^)(bool status, NSError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    [apiClient POST:kAddDirectScore parameters:[RoundDataServices paramAddDirectScore:score holeId:holeId] success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask task, NSError error) {
        failureBlock(false, error);
    }];
    
}

#pragma mark - HelperMethods

+(NSDictionary *)paramsDeleteShotId:(NSNumber *)shotId{
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"shot_id" :   shotId,
             };
}


+(NSDictionary *)paramsDeleteShotHoleId:(NSNumber *)holeId roundId:(NSNumber *)round type:(NSString *)shotType shotId:(NSNumber *)shotId{
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"hole_id" :    holeId,
             @"round_id" :   round,
             @"shot_type" :  shotType,
             @"shot_id" :   shotId,
             };
}


+(NSDictionary *)paramAddDirectScore:(NSNumber *)score holeId:(NSNumber *)holeId{

    return @{
            @"app_bundle_id" : kAppBundleId,
            @"user_agent" : kUserAgent,
            @"auth_token" : [UserServices currentToken],
            @"hole_id" :    holeId,
            @"round_id" :   round,
            @"shot_type" :  shotType,
             };
}

+(NSDictionary *)paramAddGuestToRoundEmail:(NSString *)email firstName:(NSString *)firstName lastName:(NSString *)lastName{
    return @{
             @"auth_token" : [UserServices currentToken],
             @"round_id" : [[PersistentServices sharedServices] currentRoundId],
             @"email" : email,
             @"first_name" : firstName,
             @"last_name" : lastName,
             };
    
}
+(NSDictionary *)paramsFinishRound{
    
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"round_id" : [[PersistentServices sharedServices] currentRoundId],
             @"sub_course_id" : [[PersistentServices sharedServices] currentSubCourseId],
             };
}

+(NSDictionary *)paramsStartRound{

    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"sub_course_id" : [[PersistentServices sharedServices] currentSubCourseId],
            };
}

+(NSDictionary *)paramsCreateNewCourse:(NSDictionary *)dict{
    
    return @{
            @"app_bundle_id" : kAppBundleId,
            @"user_agent" : kUserAgent,
            @"auth_token" : [UserServices currentToken],
                @"sub_course_id" : dict[@"subCourseId"],
                @"game_type_id" : dict[@"gameTypeId"],
                @"score_type_id" : dict[@"scoreTypeId"],
                @"tee_box_id" : dict[@"teeBoxId"],
                @"round_id" : dict[@"roundId"],
                };
}

@end
