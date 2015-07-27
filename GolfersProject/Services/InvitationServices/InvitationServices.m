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
#import "PersistentServices.h"
#import "MBProgressHUD.h"
#import "SharedManager.h"
#import "InvitationManager.h"

@implementation InvitationServices

+(void)getInAppUsers:(void (^)(bool status, NSArray * inAppUsers))successBlock
             failure:(void (^)(bool status, NSError * error))failureBlock{

    APIClient * apiClient = [APIClient sharedAPICLient];
    
    [apiClient GET:kInAppFriend parameters:[InvitationServices paramInAppFriend] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            NSArray * friendsList = [resp result];
            successBlock(true, friendsList);
        }else
            failureBlock(false, error);
    }];
}

+(void)getInvitationTokenForInvitee:(NSArray *)invitees
                               type:(RoundInvitationType)smsEmail
                            success:(void (^)(bool status, NSString * invitationToken))successBlock
                            failure:(void (^)(bool status, NSError * error))failureBlock{

    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    NSLog(@"%@",[InvitationServices paramsGetInvitationInvitee:invitees inviteType:smsEmail] );
    
    [apiClient POST:kGetInvitationToken parameters:[InvitationServices paramsGetInvitationInvitee:invitees inviteType:smsEmail] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * invitationToken = [responseObject valueForKey:@"invitation_token"];
        successBlock(true, invitationToken);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

+(void)getInvitationDetail:(void (^)(bool status, id roundId))successBlock
                   failure:(void (^)(bool status, NSError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    [apiClient GET:kGetInvitationDetail parameters:[InvitationServices paramGetInvitationDetail] success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

+(NSString *)getinvitationAppOpenUrlForInvitation:(NSString *)appInvitationToken{
    //http://45.56.104.68/redirect_with_invitation?invitation=2222
    return  [NSString stringWithFormat:@"%@redirect_with_invitation?invitation=%@", kInvitationRedirect, appInvitationToken];
}

#pragma mark - Helpers
+(NSDictionary *)paramGetInvitationDetail{
    return @{
             @"invitation_token" : [[InvitationManager sharedInstance] invitationToken],
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             };
}

+(NSDictionary *)paramInAppFriend{
    
    return @{
             @"auth_token" : [UserServices currentToken]
             };
}

+(NSDictionary *)paramsGetInvitationInvitee:(NSArray *)invitee inviteType:(RoundInvitationType )invitationType{
    
    
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
  
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"provider" : provider,
             @"subcourse_id" : [[PersistentServices sharedServices] currentSubCourseId],
             @"round_id" : [[PersistentServices sharedServices] currentRoundId],
             @"invite_type" : providerType,
             };
}


@end
