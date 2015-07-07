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

@end
