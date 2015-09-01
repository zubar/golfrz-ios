//
//  ScoreboardServices.m
//  GolfersProject
//
//  Created by Zubair on 7/29/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreboardServices.h"
#import "APIClient.h"
#import "Constants.h"
#import "UserServices.h"
#import "PastScore.h"
#import "UtilityServices.h"

@implementation ScoreboardServices

+(void)getScoreForUserId:(NSNumber *)userId
                  holeId:(NSNumber *)holeId
                 roundId:(NSNumber *)roundId
                 success:(void (^)(bool status, id score))successBlock
                  failure:(void (^)(bool status, GolfrzError * error))failureBlock
{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    NSLog(@"GET-INDIVIDUAL-SCORE:%@", [ScoreboardServices paramsScoreForUserId:userId holeId:holeId roundId:roundId]);
    
    [apiClient GET:kGetIndividualScore parameters:[ScoreboardServices paramsScoreForUserId:userId holeId:holeId roundId:roundId] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber * score = responseObject[@"users_score"];
        successBlock(true, score);
    } failure:^(NSURLSessionDataTask *task, id response) {
        NSDictionary * errorDict = @{@"errorMessage" : @"An unknown error occured, please refresh"};
        NSError * parseError=nil;
        GolfrzError * gError = [GolfrzError modelWithDictionary:errorDict error:&parseError ];
        failureBlock(false, gError);
    }];
}

+(void)getScoreCardForRoundId:(NSNumber *)roundId
                    subCourse:(NSNumber *)subCourseId
                      success:(void (^)(bool status, id responseObject))successBlock
                      failure:(void (^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * sharedClient = [APIClient sharedAPICLient];
    NSLog(@"GET-SCORECARD-PARAM:%@", [ScoreboardServices paramsScoreForSubCourseId:subCourseId roundId:roundId]);

    [sharedClient GET:kGetScoreCard parameters:[ScoreboardServices paramsScoreForSubCourseId:subCourseId roundId:roundId] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if(!error){
            successBlock(true, [resp result]);
        }else{
            failureBlock(false, [resp result]);
        }
    }];
}


+(void)getScorecardHistory:(void(^)(bool status, NSArray * enabledFeatures))successBlock
                   failure:(void(^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kPreviousScores parameters:[ScoreboardServices paramPastScore] completion:^(id response, NSError *error) {
        if(!error){
            NSError * parseError = nil;
            NSArray * objectsArray =  [MTLJSONAdapter modelsOfClass:[PastScore class] fromJSONArray:[[response result] objectForKey:@"user_score_history"] error:&parseError];
            successBlock(true, objectsArray);
        }else
            failureBlock(false, [response result]);
    }];
}

+(void)getTotalScoreForAllPlayersForRoundId:(NSNumber *)roundId
                                    success:(void(^)(bool status, NSDictionary * playerTotalScore))successBlock
                                    failure:(void(^)(bool status, GolfrzError * error))failureBlock
{

    APIClient * apiClient = [APIClient sharedAPICLient];
    NSLog(@"Param Total Score:%@", [ScoreboardServices paramPastScoreWithRoundId:roundId]);
    [apiClient GET:kGetAllPlayerTotalForRound parameters:[ScoreboardServices paramPastScoreWithRoundId:roundId] completion:^(id response, NSError *error) {
        if(!error){
            successBlock(true, [response result][@"users"]);
        }else
            failureBlock(false, [response result]);
    }];
}

+(void)saveScoreBoardForRoundId:(NSNumber *)roundId
                     grossScore:(NSNumber *)grossScore
                       netScore:(NSNumber *)netScore
                      skinCount:(NSNumber *)skinCount
                        success:(void(^)(bool status, id response))successBlock
                        failure:(void(^)(bool status, GolfrzError * error))failureBlock

{
    APIClient * apiClient = [APIClient sharedAPICLient];
    NSLog(@"Param SavePast Scoreboard:%@", [ScoreboardServices paramSaveScoreboardRoundId:roundId gross:grossScore net:netScore skinCount:skinCount]);
  [apiClient POST:kSaveScoreCard parameters:[ScoreboardServices paramSaveScoreboardRoundId:roundId gross:grossScore net:netScore skinCount:skinCount] completion:^(id response, NSError *error) {
      if(!error){
          successBlock(true, [response result]);
      }else
          failureBlock(false, [response result]);
  }];    
}

#pragma mark - Helper Methods

+(NSDictionary *)paramSaveScoreboardRoundId:(NSNumber *)roundId
                                      gross:(NSNumber *)grossScore
                                        net:(NSNumber *)netScore
                                  skinCount:(NSNumber *)skincount
{
    NSDictionary * param = @{
             @"round_id" : (roundId != nil ? roundId : [NSNumber numberWithInt:0]),
             @"gross_score" : (grossScore != nil ? grossScore : [NSNumber numberWithInt:0]),
             @"net_score" : (netScore != nil ? netScore : [NSNumber numberWithInt:0]),
             @"skin_count" : (skincount != nil ? skincount : [NSNumber numberWithInt:0]),
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}
+(NSDictionary *)paramPastScoreWithRoundId:(NSNumber *)roundId{
    
    NSDictionary * param = @{
             @"round_id" : roundId,
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}


+(NSDictionary *)paramPastScore{
    
    return [UtilityServices authenticationParams];
}

+(NSDictionary *)paramsScoreForSubCourseId:(NSNumber *)subCourseId roundId:(NSNumber *)roundId{

    
    NSDictionary * param = @{
             @"round_id" : roundId,
             @"sub_course_id":subCourseId
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}


+(NSDictionary *)paramsScoreForUserId:(NSNumber *)userId holeId:(NSNumber *)holeId roundId:(NSNumber *)roundId{

    NSDictionary * param = @{
             @"hole_id" : holeId,
             @"round_id" : roundId,
             @"user_id" : userId,
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}
@end
