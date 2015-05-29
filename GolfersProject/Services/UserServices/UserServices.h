//
//  UserServices.h
//  GolfersProject
//
//  Created by Zubair on 5/20/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface UserServices : NSObject

+(void)setCurrentUser:(User *)mUser;
+(User *)currentUser;

+(void)updateUserInfo:(NSString *)fName lastName:(NSString *)lastName email:(NSString *)email success:(void (^)(bool status, NSString * message))successBlock failure:(void (^)(bool status, NSError * error))failureBlock;



+(void)getUserInfo:(void (^)(bool status, User * mUser))successBlock failure:(void (^)(bool status, NSError * error))failureBlock;
@end
