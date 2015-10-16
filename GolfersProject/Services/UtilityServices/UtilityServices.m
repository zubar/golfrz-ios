//
//  UtilityServices.m
//  GolfersProject
//
//  Created by Zubair on 6/11/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "UtilityServices.h"
#import <AFNetworking/AFNetworking.h>
#import "Constants.h"
#import "UserServices.h"

@implementation UtilityServices


+(void)postData:(NSDictionary *)params
                toURL:(NSString *)url
                 success:(void (^)(bool status, NSDictionary * userInfo))successBlock
                 failure:(void (^)(bool status, NSError *error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    [apiClient POST:@"" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
    
    
}

+(NSDictionary *)authenticationParamsWithMemberId
{
    NSDictionary * param = @{
             @"member_id" : [UserServices currentUserId]
             };
    return [UtilityServices dictionaryByMergingDictionaries:param aDict:[UtilityServices authenticationParams]];
}

+(NSDictionary *)authenticationParams{
    
    return @{@"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             };
}

+(NSDictionary *)paramsCourseInfo{
    return @{
             @"app_bundle_id": kAppBundleId,
             @"user_agent" : kUserAgent
             };
}


+(NSDictionary *)dictionaryByMergingDictionaries:(NSDictionary *)authDict aDict:(NSDictionary *)paramDict
{
    NSMutableDictionary * combineDict=[[NSMutableDictionary alloc] init];
    [combineDict addEntriesFromDictionary:authDict];
    [combineDict addEntriesFromDictionary:paramDict];
    return combineDict;
}

@end
