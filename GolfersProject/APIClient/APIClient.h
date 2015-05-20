//
//  APIClient.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/18/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Overcoat/Overcoat.h>

@interface APIClient : OVCHTTPSessionManager

+(APIClient *)sharedAPICLient;
+(Class)errorModelClass;
+(NSDictionary *)modelClassesByResourcePath;

@end
