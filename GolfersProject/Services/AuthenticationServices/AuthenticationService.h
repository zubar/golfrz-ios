//
//  AuthenticationService.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/18/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@class Auth;

@interface AuthenticationService : NSObject


+(Auth *)currentAuth;

+(void)setCurrentAuth:(Auth *)authObject;


+(void)loginWithUserName:(NSString *)name password:(NSString *)password success:(void (^)(bool status, Auth *))successBlock failure:(void (^)(bool status, NSError *error))failureBlock;

    
+(void)singUpUser:(NSString * )firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password  passwordConfirmation:(NSString *)passwordConfirmation memberId:(NSString *)memberID completion:(void (^)(bool status, NSError * error))block;

+(void)resetUserPassword:(NSString *)email completion:(void (^)(bool status))successfullyPosted failure:(void (^)(bool status, NSError *error))failureBlock;

+(void)signOutUser:(void (^)(bool status))successfullyPosted failureBlock:(void (^)(bool status, NSError * error))failureBlock;


@end
