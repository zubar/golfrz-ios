//
//  InvitationServices.m
//  GolfersProject
//
//  Created by Zubair on 7/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "InvitationServices.h"
#import "APIClient.h"
#import "Constants.h"
#import "UserServices.h"
#import "GameSettings.h"
#import "MBProgressHUD.h"
#import "SharedManager.h"
#import "GameSettings.h"
#import "User.h"
#import "UtilityServices.h"
#import "Invitation.h"

@implementation InvitationServices

+(void)getInAppUsers:(void (^)(bool status, NSArray * inAppUsers))successBlock
             failure:(void (^)(bool status, GolfrzError * error))failureBlock
{    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient GET:kInAppFriend parameters:[InvitationServices paramInAppFriend] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * responseDict =(NSDictionary *)responseObject;
        NSError * error = nil;
        NSArray * objectsArray = [MTLJSONAdapter modelsOfClass:[User class] fromJSONArray:responseDict[@"in_app_user_list"] error:&error];
        if(!error) successBlock(true, objectsArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        GolfrzError * errorObject = [MTLJSONAdapter modelOfClass:[GolfrzError class] fromJSONDictionary:@{@"error_message" : @"Can not get in-app friends."} error:nil];
        failureBlock(false, errorObject);
    }];
}

+(void)getInvitationTokenForInvitee:(NSArray *)invitees
                               type:(RoundInvitationType)smsEmail
                            success:(void (^)(bool status, Invitation * curInvitation ))successBlock
                            failure:(void (^)(bool status, GolfrzError * error))failureBlock
{

    APIClient * apiClient = [APIClient sharedAPICLient];
    
    NSLog(@"GET_TOKEN:%@",[InvitationServices paramsGetInvitationInvitee:invitees inviteType:smsEmail] );

    [apiClient POST:kGetInvitationToken parameters:[InvitationServices paramsGetInvitationInvitee:invitees inviteType:smsEmail] completion:^(id response, NSError *error) {
            OVCResponse * resp = response;
        if(!error){
            NSError * parseError = nil;
            Invitation * currInvitation = [MTLJSONAdapter modelOfClass:[Invitation class] fromJSONDictionary:[resp result] error:&parseError];
            if(!error) successBlock(true, currInvitation);
        }else{
            failureBlock(false, [resp result]);
        }
    }];
}

+(void)getInvitationDetail:(void (^)(bool status, id roundId))successBlock
                   failure:(void (^)(bool status, NSError * error))failureBlock
{
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    NSLog(@"GET_INVITATION:%@", [InvitationServices paramGetInvitationDetail]);

    [apiClient GET:kGetInvitationDetail parameters:[InvitationServices paramGetInvitationDetail] success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Helpers
+(NSDictionary *)paramGetInvitationDetail{
    NSDictionary * param = @{
             @"invitation_token" : [[GameSettings sharedSettings] invitationToken]
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}

+(NSDictionary *)paramInAppFriend
{
    return [UtilityServices authenticationParams];
}

+(NSDictionary *)paramsGetInvitationInvitee:(NSArray *)invitee inviteType:(RoundInvitationType )invitationType
{
    NSDictionary * provider = nil;
    NSString * providerType = nil;
    
    switch (invitationType) {
        case RoundInvitationTypeSMS:
           provider = @{
                        @"phone_no" : invitee
                        };
            providerType = @"sms";
            break;
        case RoundInvitationTypeEmail:
            provider = @{
                         @"email" : invitee
                         };
            providerType = @"email";
            break;
        case RoundInvitationTypeInApp:
            provider = @{
                         @"email" : invitee
                         };
            providerType = @"email";
            break;
        case RoundInvitationTypeFacebook:
            provider = @{
                         @"fb" : invitee
                         };
            providerType = @"fb";
            break;
        default:
            break;
    }
  
    NSDictionary * param = @{
             @"provider" : provider,
             @"subcourse_id" : [[GameSettings sharedSettings] subCourseId],
             @"round_id" : [[GameSettings sharedSettings] roundId],
             @"invite_type" : providerType,
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}


@end
