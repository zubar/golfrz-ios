//
//  UtilityServices.h
//  GolfersProject
//
//  Created by Zubair on 6/11/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityServices : NSObject

+(void)postData:(NSDictionary *)params
          toURL:(NSString *)url
        success:(void (^)(bool status, NSDictionary * userInfo))successBlock
        failure:(void (^)(bool status, NSError *error))failureBlock;

@end
