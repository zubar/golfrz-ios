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

@end
