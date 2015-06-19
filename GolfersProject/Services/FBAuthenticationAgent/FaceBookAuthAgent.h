//
//  FaceBookAuthAgent.h
//  GolfersProject
//
//  Created by Zubair on 5/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceBookAuthAgent : NSObject

+(void)signInWithFacebook:(void (^)(bool status, NSDictionary * userInfo))successBlock
                  failure:(void (^)(bool status, NSError * error))failureBlock;

+(BOOL)hasValidToken;
@end
