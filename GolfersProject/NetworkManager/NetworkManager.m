//
//  NetworkManager.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "NetworkManager.h"
#import "Constants.h"

@implementation NetworkManager

+(NetworkManager *)sharedNetworkManager
{
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return sharedInstance;
    
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

-(void)signUpUserWithBlock:(NSDictionary *)params success:(void (^)(BOOL success, NSError *error,id responseObject))success
{
    
    [self POST:USER_SIGN_UP parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        success(YES, nil,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(NO, error,nil);
    }];
}

@end
