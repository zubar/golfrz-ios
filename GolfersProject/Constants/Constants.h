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
#define KUSER_NAME  @"user_name"

#define kScreenWidth (NSInteger)[[UIScreen mainScreen] bounds].size.width
#define kScreenHeight (NSInteger)[[UIScreen mainScreen] bounds].size.height



static NSString * const kAppStoreUrl = @"https://fb.me/1587823924813232";
static NSString * const kAppPreviewImage = @"http://a5.mzstatic.com/us/r30/Purple1/v4/14/9d/66/149d6659-a6c7-9d30-ff50-49b84013a4b6/icon175x175.jpeg";

/*
 * BaseImageURLGolfrz
 */
static NSString * const kBaseImageUrl = @"http://45.56.104.68";
//static NSString * const kBaseImageUrl = @"https://www.mobilecoursesolutions.com";

static NSString * const kBaseURL = @"http://45.56.104.68/api/0.1/";
//static NSString * const kBaseURL = @"https://www.mobilecoursesolutions.com/api/0.1/";


/*
 This URL is used to create a app open link via a server redirect.
 */
static NSString * const kInvitationRedirect = @"http://45.56.104.68/";
//static NSString * const kInvitationRedirect = @"https://www.mobilecoursesolutions.com/";


/*
 * Weather API
 */
static NSString * const kWeatherAPI = @"http://api.openweathermap.org/data/2.5/";
// Weather API by Dustion
static NSString * const kWeatherAPIKey = @"ca770f97be3145f111acb65c4c47b9dd";

/*
 * Authentication Services
 * SignIn, SignOut
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
 * Golf Course Data Services
 */
static NSString * const kCourseInfo = @"courses/info";
static NSString * const kCourseDetail = @"courses/course_detail";
static NSString * const kCheckInUrl = @"check_in";
static NSString * const kFeatureUrl =@"features/list";

/*
 * InApp Friends
 */
static NSString * const kInAppFriend = @"users/in_app_user_list";


//TODO: get it from bundle id,
#pragma warking - Automation issue.
//static NSString * const kAppBundleId = @"com.golfrz.genevagcc";
static NSString * const kAppBundleId = @"org.golfrz.GolferzProject99";
//static NSString * const kAppBundleId = @"org.golfrz.GolferzProject";
static NSString * const kUserAgent = @"ios";


/*
 * Events
 */
static NSString * const kCalenderEventsList = @"events";


/*
 * Food & Beverage
 */
static NSString * const kFoodAndBeverage = @"menus/get_menu_list";
static NSString * const kAddItemToCart = @"menus/add_to_cart"; 
static NSString * const kRemoveFromCart = @"menus/remove_from_cart";
static NSString * const kViewCart = @"menus/view_user_cart";
static NSString * const kConfirmCartOrder = @"menus/place_order";

/*
 * Rounds
 */
// API lists down the available subcourses, holes & rounds.
static NSString * const kRoundInSubCourse = @"rounds/fetch_rounds_dropdowns";
static NSString * const kRoundNew = @"rounds/new";
static NSString * const kRoundStart = @"rounds/start";
static NSString * const kRoundFinish = @"rounds/finish";
static NSString * const kRoundAddGuest = @"rounds/create_guest";
static NSString * const kRoundPlayers = @"rounds/round_players";
static NSString * const kRoundInfo = @"rounds/round_info";
static NSString * const kRoundInProgress = @"rounds/last_round_info";


/*
 * Adding Scores/Shots
 */
static NSString * const kAddDirectScore = @"shots/direct_score";
static NSString * const kAddShot = @"shots/play";
static NSString * const kDeleteShot = @"shots/delete_shot";


/*
 * Round Invitation
 */
static NSString * const kGetInvitationToken = @"invitations/send_invitation";
static NSString * const kGetInvitationDetail = @"invitations/get_invitation";
static NSString * const kInvitationAppOpen = @"%@/redirect_with_invitation?id=%@";

/*
 * Scoreboard Services
 */
static NSString * const kGetIndividualScore = @"scores/individual_score";
static NSString * const kGetScoreCard = @"scores/score_card";
static NSString * const kPreviousScores = @"scores/previous_score_cards";
static NSString * const kGetAllPlayerTotalForRound = @"rounds/user_shots";
static NSString * const kSaveScoreCard = @"scores/save_score_card";

/*
 *  Push notification token registeration
 */
static NSString * const kPushRegURL = @"push_registrations/register";

/*
 *  Teetimes
 */
static NSString * const kGetteetimes = @"tee_times/tee_times";
static NSString * const kBookTeetime = @"tee_times/book_tee_time";
static NSString * const kUpdateTeetime = @"tee_times/update_tee_time";

/*
 * Notification Names
 */
static NSString * const kUserLoginSuccessful = @"UserLoginSuccessfulWithServerTokenAcquired";
static NSString * const kInviteeAcceptedInvitation = @"InviteeAcceptedRoundInvitation";
static NSString * const kInviteeRejectedInvitation = @"InviteeRejectedRoundInvitation";
static NSString * const kInvitationReceived = @"InvitationReceivedForRound";
static NSString * const kAppLaunchUserTapInvitationLink = @"AppLaunchDueToUserTapOnInvitationLink";
static NSString * const kRedeemedReward = @"RedeemedRewardUpdateUserPoints";

/*
 *  CourseUpdates
 */
static NSString * const kCourseUpdatesList = @"notifications/view_notification_list";
static NSString * const kGetDetailCommentsOnThread = @"notifications/view_notification_comments";
static NSString * const KPostComment = @"notifications/add_comment";
static NSString * const KAddKudos = @"notifications/kudos";

/*
 *  Rewards
 */
static NSString * const kRewardsList = @"rewards/all";
static NSString * const kRewardDetail = @"rewards/reward_id";
static NSString * const kRewardRedeem = @"rewards/redeem";
static NSString * const kRewardUserTotalPoints = @"rewards/fetch_points";

/*
 * Featured Control Names
 */
static NSString * const kFeatEventCalendar = @"event_calendar";
static NSString * const kFeatTeetime = @"tee_time";
static NSString * const kFeatFoodAndBeverages = @"food_&_beverages";
static NSString * const kFeatLeaguesAndTournaments = @"leagues_&_tournaments";
static NSString * const kFeatNewsFeed = @"news_feeds";

//================================= Presentation ======================================

static NSString * const kDefaultThemeColor = @"0xFF0000";

/*
 * OK Message
 */
static NSString * const kOK = @"OK";

/*
 * Error Messages
 */
static NSString * const kError = @"Error";
static NSString * const kReqiredFieldErrorMessage = @"Required Field Missing.";
static NSString * const kNoInternetErrorTitle = @"Internet Connection Lost !";
static NSString * const kNoInternetErrorDetial = @"Internet Connection can not be established now, please try again later.";
static NSString * const kFailedToConnectAppServerTitle = @"Failed to Connect App Server !";
static NSString * const kFailedToConnectAppServerDetail = @"Application server is not responding at the moment, please try again later.";
static NSString * const kFirstNameEmptyErrorMessage = @"Please enter first name.";
static NSString * const kLastNameEmptyErrorMessage = @"Please enter last name.";
static NSString * const kEmailErrorMessage = @"Please enter valid email address.";
static NSString * const kNumberHandicapErrorMessage = @"Please a number for handicap.";
static NSString * const kAddGuestErrorMessage = @"Unable to add guest.";
static NSString * const kTeeBoxErrorMessage = @"Please select a teebox.";
static NSString * const NumberNotAvaliableErrorMessage  = @"Number not avaliable!";
static NSString * const CallSupportErrorMessage  = @"Your device doesn't support call!";
static NSString *const EmailSupportErrorMessage = @"Your device doesn't support e-mail!"

/*
 * Success Messages
 */
static NSString * const kSuccess = @"Success";
static NSString * const kAddGuestSuccessMessage = @"Guest successfully added.";

/*
 * Reward Tutorial Messages
 */

static NSString * const RewardTutorialHeading = @"Here you can see how to earn points as well as claim your rewards!";
static NSString * const CheckInReward = @"Earn 5 points every time you check in to the course.";
static NSString * const InviteFriendsReward = @"Earn 25 points for each friend you invite to the app.";
static NSString * const SocialMediaReward = @"Earn 5 more points for each social network you post on.";
static NSString * const ScoreCardReward = @"Earn 10 points for every Scorecard you post to your Player Profile.";
static NSString * const RoundsReward =@"Finally, earn points when you finish 5, 10 or 25 consecutive rounds.";
static NSString * const FinalRewardHeading = @"Then, it's time to collect your rewards!";

//=======================================================================

#define UIColorFromHex(rgbValue) [UIColor \
colorWithRed: ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green: ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue: ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]
#endif

