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
#import "GameSettings.h"
#import "Round.h"
#import "RoundPlayers.h"

@implementation RoundDataServices


+(void)getRoundData:(void (^)(bool status, RoundMetaData * subCourse))successBlock
            failure:(void (^)(bool status, NSError * error))failureBlock{

    APIClient * apiClient = [APIClient sharedAPICLient];
    
    [apiClient GET:kRoundInSubCourse parameters:[UtilityServices authenticationParams] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            RoundMetaData * mRoundData = [resp result];
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

    [apiClient POST:endPoint parameters:[RoundDataServices paramsCreateRound:options] success:^(NSURLSessionDataTask *task, id responseObject) {
        
            NSUInteger  tRoundId = [[responseObject valueForKeyPath:@"round.id"] integerValue];
            NSNumber *  roundId = [NSNumber numberWithInteger:tRoundId];
            [[GameSettings sharedSettings] setroundId:roundId];
            successBlock(true, roundId);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
    
}

+(void)startNewRoundWithId:(NSNumber *)roundId
               subCourseId:(NSNumber *)subcourseId
                   success:(void (^)(bool status, id roundId))successBlock
                   failure:(void (^)(bool status, NSError * error))failureBlock{
    
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    [apiClient POST:kRoundStart parameters:[RoundDataServices
                                            paramStartRoundWithId:roundId subCourseId:subcourseId]
    success:^(NSURLSessionDataTask *task, id responseObject) {
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
              shotType:(ShotType )shotType
               success:(void(^)(bool, id))successBlock
               failure:(void(^)(bool, id))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kRoundAddGuest parameters:[RoundDataServices paramsAddShotholeId:holeId roundId:round shortType:shotType]
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
             playerId:(NSNumber *)playerId
              success:(void(^)(bool status, NSDictionary * response))successBlock
              failure:(void(^)(bool status, NSError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    [apiClient POST:kAddDirectScore parameters:[RoundDataServices paramAddDirectScore:score holeId:holeId playerId:playerId] success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failureBlock(false, error);
    }];
    
}

+(void)updateRound:(void(^)(bool status, id response))successBlock
           failure:(void(^)(bool status, NSError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    [apiClient POST:kAddDirectScore parameters:[RoundDataServices paramsUpdateRound] success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failureBlock(false, error);
    }];
    
}

+(void)getPlayersInRoundId:(NSNumber *)roundId
                   success:(void(^)(bool, RoundPlayers * players))successBlock
                    failure:(void(^)(bool, NSError * error))failureBlock{
   
    APIClient * apiClient = [APIClient sharedAPICLient];
    
    [apiClient GET:kRoundPlayers parameters:[RoundDataServices paramsGetRoundInfoForRound:roundId] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            RoundPlayers * mPlayers = [resp result];
            successBlock(true, mPlayers);
        }else
            failureBlock(false, error);
    }];
}

+(void)getRoundInfoForRoundId:(NSNumber *)roundId
                      success:(void(^)(bool status, Round * round))successBlock
                      failure:(void(^)(bool status, NSError * error))failureBlock{

    APIClient * apiClient = [APIClient sharedAPICLient];
    
    [apiClient GET:kRoundInfo parameters:[RoundDataServices paramsGetRoundInfoForRound:roundId] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            Round  * mRound = [resp result];
            successBlock(true, mRound);
        }else
            failureBlock(false, error);
    }];
}

#pragma mark - HelperMethods
+(NSDictionary *)paramStartRoundWithId:(NSNumber *)roundId subCourseId:(NSNumber * )subcourseId{
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"round_id" :    roundId,
             @"sub_course_id" : subcourseId,
             };
}

+(NSDictionary *)paramsGetRoundInfoForRound:(NSNumber *)roundId{
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"round_id" :    roundId,
            };

}

+(NSDictionary *)paramsAddShotholeId:(NSNumber *)holeId roundId:(NSNumber *)round shortType:(ShotType )type{
    
    NSString * shotTypeString = nil;
    
    if (type == ShotTypeStardard) shotTypeString = @"shot";
    else if (type == ShotTypePutt) shotTypeString = @"putt";
    else if (type == ShotTypePenalty) ShotTypePenalty = @"penalty";

    
    
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"hole_id" :    holeId,
             @"round_id" :   round,
             @"shot_type" :  shotTypeString,
             };
    
}

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


+(NSDictionary *)paramAddDirectScore:(NSNumber *)score holeId:(NSNumber *)holeId playerId:(NSNumber *)playerId{

    return @{
            @"app_bundle_id" : kAppBundleId,
            @"user_agent" : kUserAgent,
            @"auth_token" : [UserServices currentToken],
            @"hole_id" :    holeId,
            @"round_id" :   [[GameSettings sharedSettings] roundId],
            @"user_id" : playerId
             };
}

+(NSDictionary *)paramAddGuestToRoundEmail:(NSString *)email firstName:(NSString *)firstName lastName:(NSString *)lastName{
    return @{
             @"auth_token" : [UserServices currentToken],
             @"round_id" : [[GameSettings sharedSettings] roundId],
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
             @"round_id" : [[GameSettings sharedSettings] roundId],
             @"sub_course_id" : [[GameSettings sharedSettings] subCourseId],
             };
}

+(NSDictionary *)paramsStartRound{

    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"sub_course_id" : [[GameSettings sharedSettings] subCourseId],
            };
}

+(NSDictionary *)paramsCreateRound:(NSDictionary *)dict{
    
    return @{
            @"app_bundle_id" : kAppBundleId,
            @"user_agent" : kUserAgent,
            @"auth_token" : [UserServices currentToken],
                @"sub_course_id" : dict[@"subCourseId"],
                @"game_type_id" : dict[@"gameTypeId"],
                @"score_type_id" : dict[@"scoreTypeId"],
                @"tee_box_id" : dict[@"teeBoxId"],
                };
}

+(NSDictionary *)paramsUpdateRound{
    
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"sub_course_id" : [[GameSettings sharedSettings] subCourseId],
             @"game_type_id" : [[GameSettings sharedSettings] gameTypeId],
             @"score_type_id" : [[GameSettings sharedSettings] scoreTypeId],
             @"tee_box_id" : [[GameSettings sharedSettings] teeboxId],
             @"round_id	" : [[GameSettings sharedSettings] roundId],
             };
}
@end
