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
#import "GolfrzError.h"
#import "Shot.h"

@implementation RoundDataServices


+(void)getRoundData:(void (^)(bool status, RoundMetaData * subCourse))successBlock
            failure:(void (^)(bool status, GolfrzError * error))failureBlock{

    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kRoundInSubCourse parameters:[UtilityServices authenticationParams] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            RoundMetaData * mRoundData = [resp result];
            successBlock(true, mRoundData);
        }else
            failureBlock(false, [response result]);
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
                   failure:(void (^)(bool status, NSError * error))failureBlock
{
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    NSLog(@"Round-Star: %@", [RoundDataServices
                                 paramStartRoundWithId:roundId subCourseId:subcourseId]);
    [apiClient POST:kRoundStart parameters:[RoundDataServices
                                            paramStartRoundWithId:roundId subCourseId:subcourseId]
    success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Round-Star:%@", responseObject);
            successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
    
}

+(void)finishRoundWithBlock:(void(^)(bool status, id response))successBlock
                    failure:(void(^)(bool status, NSError * error))failureBlock
{
    
    NSLog(@"param finsihRoudn: %@", [RoundDataServices paramsFinishRound]);
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kRoundFinish parameters:[RoundDataServices paramsFinishRound] success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
}

+(void)addGuestWithEmail:(NSString *)email
               firstName:(NSString *)fName
                lastName:(NSString *)lName
                handicap:(NSNumber *)handicap
                teeBoxId:(NSNumber *)teeBoxId
                 success:(void(^)(bool status, NSDictionary * response))successBlock
                 failure:(void(^)(bool status, NSError * error))failureBlock
{
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    NSLog(@"PARAM-ADD-GUEST:%@", [RoundDataServices paramAddGuestToRoundEmail:email firstName:fName lastName:lName handicap:handicap teeBoxId:teeBoxId]);
    [apiClient POST:kRoundAddGuest parameters:[RoundDataServices paramAddGuestToRoundEmail:email firstName:fName lastName:lName handicap:handicap teeBoxId:teeBoxId] success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
    
}

+(void)addShotRoundId:(NSNumber *)round
                holeId:(NSNumber *)holeId
              shotType:(ShotType )shotType
               success:(void(^)(bool, id response))successBlock
               failure:(void(^)(bool,  NSError *error))failureBlock
{
    NSLog(@"SHOT: %@", [RoundDataServices paramsAddShotholeId:holeId roundId:round shortType:shotType]);
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kAddShot parameters:[RoundDataServices paramsAddShotholeId:holeId roundId:round shortType:shotType]
            success:^(NSURLSessionDataTask *task, id responseObject) {
                NSError * tError = nil;
                Shot * tempShot = [MTLJSONAdapter modelOfClass:[Shot class] fromJSONDictionary:responseObject[@"shot"] error:&tError];
                if(!tError)
                    successBlock(true, tempShot);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(error != nil) failureBlock(false, error);
    }];
}


+(void)deleteShot:(Shot *)mShot
                 success:(void(^)(bool, id response))successBlock
                 failure:(void(^)(bool,  NSError *error))failureBlock
{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient DELETE:kDeleteShot parameters:[RoundDataServices paramsDeleteShot:mShot] success:^(NSURLSessionDataTask *task, id responseObject)
    {
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
}

+(void)deleteShotRoundId:(NSNumber *)round
                holeId:(NSNumber *)holeId
              shotType:(ShotType )shotType
                shotId:(NSNumber *)shotId
               success:(void(^)(bool, id response))successBlock
               failure:(void(^)(bool, NSError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kDeleteShot parameters:[RoundDataServices
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
    
    NSLog(@"%@", [RoundDataServices paramAddDirectScore:score holeId:holeId playerId:playerId]);
    
    [apiClient POST:kAddDirectScore parameters:[RoundDataServices paramAddDirectScore:score holeId:holeId playerId:playerId] success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failureBlock(false, error);
    }];
    
}

+(void)updateRound:(void(^)(bool status, id response))successBlock
           failure:(void(^)(bool status, NSError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    NSLog(@"Round New:%@", [RoundDataServices paramsUpdateRound]);

    [apiClient POST:kRoundNew parameters:[RoundDataServices paramsUpdateRound] success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"Round New Response:%@", responseObject);

        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failureBlock(false, error);
    }];
    
}

+(void)getPlayersInRoundId:(NSNumber *)roundId
                   success:(void(^)(bool, RoundPlayers * players))successBlock
                    failure:(void(^)(bool, GolfrzError * error))failureBlock{
   
    APIClient * apiClient = [APIClient sharedAPICLient];
    
    [apiClient GET:kRoundPlayers parameters:[RoundDataServices paramsGetRoundInfoForRound:roundId] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            RoundPlayers * mPlayers = [resp result];
            successBlock(true, mPlayers);
        }else
            failureBlock(false, [response result]);
    }];
}

+(void)getRoundInfoForRoundId:(NSNumber *)roundId
                      success:(void(^)(bool status, Round * round))successBlock
                      failure:(void(^)(bool status, GolfrzError * error))failureBlock
{

    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kRoundInfo parameters:[RoundDataServices paramsGetRoundInfoForRound:roundId] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            Round  * mRound = [resp result];
            successBlock(true, mRound);
        }else
            failureBlock(false, [response result]);
    }];
}

+(void)getRoundInProgress:(void(^)(bool status, NSNumber * roundNo, NSNumber * subCourseId, NSString * teeboxName))successBlock
           finishedRounds:(void(^)(bool status))roundsFinished
                  failure:(void(^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kRoundInProgress parameters:[RoundDataServices paramUserAuthentication] completion:^(id response, NSError *error) {
        if(!error){
            successBlock(true,[[response result] valueForKeyPath:@"round.id"], [[response result] valueForKeyPath:@"round.sub_course_id"], [[response result] valueForKeyPath:@"round.tee_box_name"]);
        }else
            if([[response result] isKindOfClass:[GolfrzError class]]){
                roundsFinished(true);
            }else{
                failureBlock(false, [response result]);
        }
    }];
}

#pragma mark - HelperMethods

+(NSDictionary *)paramUserAuthentication{

    return [UtilityServices authenticationParams];
}

+(NSDictionary *)paramStartRoundWithId:(NSNumber *)roundId
                           subCourseId:(NSNumber * )subcourseId
{
    NSDictionary * param = @{
             @"round_id" :    roundId,
             @"sub_course_id" : subcourseId,
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}

+(NSDictionary *)paramsGetRoundInfoForRound:(NSNumber *)roundId
{
    NSDictionary * param = @{
             @"round_id" :    roundId,
            };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}

+(NSDictionary *)paramsAddShotholeId:(NSNumber *)holeId
                             roundId:(NSNumber *)round
                           shortType:(ShotType )type
{
    NSString * shotTypeString = nil;
    if (type == ShotTypeStardard) shotTypeString = @"shot";
    else if (type == ShotTypePutt) shotTypeString = @"putt";
    else if (type == ShotTypePenalty) shotTypeString = @"penalty";
    NSDictionary * param = @{
             @"hole_id" :    holeId,
             @"round_id" :   round,
             @"shot_type" :  shotTypeString,
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}

+(NSDictionary *)paramsDeleteShot:(Shot *)mShot
{
    NSDictionary * param = @{
             @"shot_id" :   [mShot itemId],
             @"round_id" : [mShot roundId],
             @"hole_id" : [mShot holeId],
             @"shot_type" : [mShot shotType],
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}


+(NSDictionary *)paramsDeleteShotHoleId:(NSNumber *)holeId
                                roundId:(NSNumber *)round
                                   type:(ShotType )type
                                 shotId:(NSNumber *)shotId
{
    NSString * shotType;
    if(type == ShotTypeStardard) shotType = @"shot";
    else if(type == ShotTypePutt) shotType = @"putt";
    else if(type == ShotTypePenalty) shotType = @"penalty";
    NSDictionary * param = @{
             @"hole_id" :    holeId,
             @"round_id" :   round,
             @"shot_type" :  shotType,
             @"shot_id" :   shotId,
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}


+(NSDictionary *)paramAddDirectScore:(NSNumber *)score
                              holeId:(NSNumber *)holeId
                            playerId:(NSNumber *)playerId
{
        NSDictionary * param = @{
                 @"hole_id" :    holeId,
                 @"round_id" :   [[GameSettings sharedSettings] roundId],
                 @"user_id" : playerId,
                 @"score" : score,
                 };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}

+(NSDictionary *)paramAddGuestToRoundEmail:(NSString *)email
                                firstName:(NSString *)firstName
                                 lastName:(NSString *)lastName
                                 handicap:(NSNumber *)handicap
                                 teeBoxId:(NSNumber *)teeBoxId
{
    NSDictionary * param = @{
             @"round_id" : [[GameSettings sharedSettings] roundId],
             @"email" : email,
             @"first_name" : firstName,
             @"last_name" : lastName,
             @"handicap" : handicap,
             @"tee_box_id" : teeBoxId,
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}

+(NSDictionary *)paramsFinishRound{
    
    NSDictionary * param = @{
             @"round_id" : [[GameSettings sharedSettings] roundId],
             @"sub_course_id" : [[GameSettings sharedSettings] subCourseId],
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}

+(NSDictionary *)paramsCreateRound:(NSDictionary *)dict{
    
    NSMutableDictionary * paramDict = [NSMutableDictionary new];
    
    [paramDict setObject:kAppBundleId forKey:@"app_bundle_id"];
    [paramDict setObject:kUserAgent forKey:@"user_agent"];
    [paramDict setObject:[UserServices currentToken] forKey:@"auth_token"];
    [paramDict setObject:dict[@"subCourseId"] forKey:@"sub_course_id"];
    [paramDict setObject:dict[@"gameTypeId"] forKey:@"game_type_id"];
    [paramDict setObject:dict[@"scoreTypeId"] forKey:@"score_type_id"];
    [paramDict setObject:dict[@"teeBoxId"] forKey:@"tee_box_id"];
    
    if(dict[@"roundId"] != nil) [paramDict setObject:dict[@"roundId"] forKey:@"round_id"];
    
    return paramDict;
}

+(NSDictionary *)paramsUpdateRound{
    
    NSDictionary * param = @{
             @"sub_course_id" : [[GameSettings sharedSettings] subCourseId],
             @"game_type_id" : [[GameSettings sharedSettings] gameTypeId],
             @"score_type_id" : [[GameSettings sharedSettings] scoreTypeId],
             @"tee_box_id" : [[GameSettings sharedSettings] teeboxId],
             @"round_id" : [[GameSettings sharedSettings] roundId],
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}
@end
