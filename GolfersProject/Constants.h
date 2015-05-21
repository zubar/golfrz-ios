//
//  Constants.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#ifndef GolfersProject_Constants_h
#define GolfersProject_Constants_h


/*
 * BaseImageURLGolfrz
 */
static NSString * const kBaseImageUrl = @"https://powerful-plains-9156.herokuapp.com/";


/*
 *  Authentication Services
 *  SignIn, SignOut
 */
static NSString * const kBaseURL = @"https://powerful-plains-9156.herokuapp.com/api/";
static NSString * const kSignInURL = @"users/sign_in";
static NSString * const kForgetPasswordURL = @"users/password";
static NSString * const kSignOutURL = @"users/sign_out";
static NSString * const kSignUpURL = @"users";

/*
 *  Golf Course Data Services
 *  SignIn, SignOut
 */
static NSString * const kCourseInfo = @"course/info";
//TODO: get it from bundle id,
#pragma warking - Automation issue.
static NSString * const kAppBundleId = @"com.golfrz.sedona";
static NSString * const kUserAgent = @"iOS";




#endif

