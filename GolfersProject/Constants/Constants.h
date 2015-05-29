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
//static NSString * const kBaseImageUrl = @"https://powerful-plains-9156.herokuapp.com/";
static NSString * const kBaseImageUrl = @"https://golfrz-api.herokuapp.com/";

static NSString * const kBaseURL = @"https://golfrz-api.herokuapp.com/api/0.1/";


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
static NSString * const kSignOutURL = @"sessions";
static NSString * const kSignUpURL = @"users/sign_up";
static NSString * const kUpdateUserInfo = @"users/";


/*
 * Users detail
 */
static NSString * const kUserInfo = @"users/";
/*
 *  Golf Course Data Services
 */
static NSString * const kCourseInfo = @"courses/info";
static NSString * const kCourseDetail = @"courses/course_detail";


//TODO: get it from bundle id,
#pragma warking - Automation issue.
static NSString * const kAppBundleId = @"org.golfrz.GolfrzProject";
static NSString * const kUserAgent = @"iOS";


/*
 * Events
 */
static NSString * const kCalenderEventsList = @"events";

#endif

