//
//  NetworkManager.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

@interface NetworkManager : AFHTTPRequestOperationManager

+(NetworkManager *)sharedNetworkManager;
- (instancetype)initWithBaseURL:(NSURL *)url;

-(void)signUpUserWithBlock:(NSDictionary *)params success:(void (^)(BOOL success, NSError *error,id responseObject))success;

@end
