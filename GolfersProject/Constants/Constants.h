//
//  Constants.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#ifndef GolfersProject_Constants_h
#define GolfersProject_Constants_h


#define kUSER_TOKEN @"user_token"
#define kUSER_EMAIL @"user_email"
#define kUSER_ID    @"user_id"
 



/*
 * BaseImageURLGolfrz
 */
static NSString * const kBaseImageUrl = @"https://powerful-plains-9156.herokuapp.com/";
//static NSString * const kBaseImageUrl = @"https://golfrz-api.herokuapp.com";

//static NSString * const kBaseURL = @"https://golfrz-api.herokuapp.com/api/0.1/";
static NSString * const kBaseURL = @"https://powerful-plains-9156.herokuapp.com/api/0.1/";



/*
 * Weather API
 */
static NSString * const kWeatherAPI = @"http://api.openweathermap.org/data/2.5/";
static NSString * const kWeatherAPIKey = @"e5bfb7faf3d0c719e87f3e1300ad0739";

/*
 *  Authentication Services
 *  SignIn, SignOut
 */
static NSString * const kSignInURL = @"sessions";
static NSString * const kForgetPasswordURL = @"users/forgot_password";
static NSString * const kSignOutURL = @"sessions/";

/*
 * Users detail
 */
static NSString * const kUserInfo = @"users/";
static NSString * const kSignUpURL = @"users/sign_up";
static NSString * const kUpdateUserInfo = @"users/";

/*
 *  Golf Course Data Services
 */
static NSString * const kCourseInfo = @"courses/info";
static NSString * const kCourseDetail = @"courses/course_detail";


//TODO: get it from bundle id,
#pragma warking - Automation issue.
static NSString * const kAppBundleId = @"org.golfrz.GolferzProject";
static NSString * const kUserAgent = @"iOS";


/*
 * Events
 */
static NSString * const kCalenderEventsList = @"events";


//================================= Presentation ======================================

static NSString * const kDefaultThemeColor = @"0xFF0000";



#endif

