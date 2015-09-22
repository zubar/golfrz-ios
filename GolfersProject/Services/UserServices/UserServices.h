//
//  UserServices.h
//  GolfersProject
//
//  Created by Zubair on 5/20/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@class GolfrzError;

@interface UserServices : NSObject

+(User *)currentUser;



+(void)setCurrentUSerName:(NSString *)name;
+(NSString *)currentUserName;


+(void)setCurrentToken:(NSString *)token;
+(NSString *)currentToken;

+(NSString *)currentUserId;
+(void)setCurrentUserId:(NSString *)memberId;

+(NSString *)currentUserEmail;
+(void)setCurrentUserEmail:(NSString *)email;

+(void)getUserInfo:(void (^)(bool status, User * mUser))successBlock
           failure:(void (^)(bool status, GolfrzError * error))failureBlock;

+(void)updateUserInfo:(NSString *)fName
             lastName:(NSString *)lastName
                email:(NSString *)email
              phoneNo:(NSString *)phoneNo
             handicap:(NSNumber *)handicap
              success:(void (^)(bool status, NSString * message))successBlock
              failure:(void (^)(bool status, GolfrzError * error))failureBlock;

/*+(void)getUserInfoAndFBImage:(NSString *)userId success:(void (^)(bool status, User * mUser))successBlock
                     failure:(void (^)(bool status, GolfrzError * error))failureBlock;*/

@end
