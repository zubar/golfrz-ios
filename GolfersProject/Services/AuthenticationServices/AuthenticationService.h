//
//  AuthenticationService.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/18/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationService : NSObject

+(void)loginWithUserName:(NSString *)name password:(NSString *)password;

@end
