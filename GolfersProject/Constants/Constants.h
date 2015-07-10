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
 

static NSString * const kAppStoreUrl = @"https://fb.me/1587823924813232";
static NSString * const kAppPreviewImage = @"http://a5.mzstatic.com/us/r30/Purple1/v4/14/9d/66/149d6659-a6c7-9d30-ff50-49b84013a4b6/icon175x175.jpeg";

/*
 * BaseImageURLGolfrz
 */
static NSString * const kBaseImageUrl = @"";//@"https://powerful-plains-9156.herokuapp.com";
//static NSString * const kBaseImageUrl = @"https://golfrz-api.herokuapp.com";

static NSString * const kBaseURL = @"http://45.56.104.68/api/0.1/";
//static NSString * const kBaseURL = @"https://powerful-plains-9156.herokuapp.com/api/0.1/";


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
static NSString * const kSignUpWithFacebook = @"users/sign_up_facebook";

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
static NSString * const kCheckInUrl = @"check_in";


//TODO: get it from bundle id,
#pragma warking - Automation issue.
static NSString * const kAppBundleId = @"org.golfrz.GolferzProject";
static NSString * const kUserAgent = @"ios";


/*
 * Events
 */
static NSString * const kCalenderEventsList = @"events";


/*
 *  Food & Beverage
 */
static NSString * const kFoodAndBeverage = @"menus/get_menu_list";
static NSString * const kAddItemToCart = @"menus/add_to_cart"; 
static NSString * const kRemoveFromCart = @"menus/remove_from_cart";
static NSString * const kViewCart = @"menus/view_user_cart";
static NSString * const kConfirmCartOrder = @"menus/place_order";

/*
 *  Rounds
 */
// API lists down the available subcourses, holes & rounds.
static NSString * const kRoundInSubCourse = @"rounds/fetch_rounds_dropdowns";
static NSString * const kRoundNew = @"/rounds/new";


/*
 *  Push notification token registeration
 */
static NSString * const kPushRegURL = @"push_registrations/register";

/*
 * Notif
 */
static NSString * const kUserLoginSuccessful = @"UserLoginSuccessfulWithServerTokenAcquired";

//================================= Presentation ======================================

static NSString * const kDefaultThemeColor = @"0xFF0000";



#endif

