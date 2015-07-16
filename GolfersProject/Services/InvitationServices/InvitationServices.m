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

+(void)getInvitationToken:(void (^)(bool status, NSString * invitationToken))successBlock
                  failure:(void (^)(bool status, NSError * error))failureBlock{

    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kWeatherAPI]];
    
    [apiClient POST:kGetInvitationToken parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * invitationToken = [responseObject valueForKey:@"invitation_token"];
        successBlock(true, invitationToken);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

+(void)getInvitationDetail:(void (^)(bool status, NSString * invitationToken))successBlock
                   failure:(void (^)(bool status, NSError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kWeatherAPI]];
    
    [apiClient GET:kGetInvitationDetail parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * invitationToken = [responseObject valueForKey:@"invitation_token"];
        successBlock(true, invitationToken);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

+(NSString *)getinvitationAppOpenUrlForInvitation:(NSString *)appInvitationToken{
    return  [NSString stringWithFormat:@"%@%@", kInvitationRedirect, appInvitationToken];
}

#pragma mark - Helpers
+(NSDictionary *)paramInAppFriend{
    
    return @{
             @"auth_token" : [UserServices currentToken]
             };
}


@end
