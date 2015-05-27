//
//  UserServices.m
//  GolfersProject
//
//  Created by Zubair on 5/20/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "UserServices.h"
#import "User.h"

@implementation UserServices

static User * currentUser = nil;


+(void)setCurrentUser:(User *)mUser{
    currentUser = mUser;
}

+(User *)currentUser{
    return currentUser;
}

//+(void)updateUserInfo:



#pragma mark - Helper Methods

//+(NSDictionary *)userInfo:(NSString *)userEmail


@end
