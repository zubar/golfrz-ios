//
//  APIClient.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/18/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "APIClient.h"
#import "Constants.h"
#import "Course.h"
#import "CalendarEvent.h"
#import "EventList.h"
#import "User.h"
#import "Menu.h"
#import "Cart.h"
#import "SubCourse.h"
#import "RoundMetaData.h"
#import "RoundPlayers.h"
#import "Round.h"
#import "GolfrzError.h"
#import "TeetimeData.h"
#import "CourseUpdate.h"
#import "Post.h"


@implementation APIClient

+(APIClient *)sharedAPICLient{
    
    static APIClient *_aPIClient = nil;
    
    static dispatch_once_t onceToken;
    //Use Grand Central Dispatch to create a single instance and do any initial setup only once.
    dispatch_once(&onceToken, ^{
        //These are only invoked the onceToken has never been used before.
        _aPIClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    return _aPIClient;
}

#pragma mark - OVCHTTPSessionManager

+ (Class)errorModelClass {
    return [GolfrzError class];
}


+(NSDictionary *)modelClassesByResourcePath{
    
    return @{
             kCourseDetail : [Course class],
             kCalenderEventsList : [EventList class],
             @"users/*" : [User class],
             @"users" : [User class],
             kFoodAndBeverage : [Menu class],
             kViewCart : [Cart class],
             kRoundInSubCourse : [RoundMetaData class],
             kRoundPlayers : [RoundPlayers class],
             kRoundInfo : [Round class],
             kGetteetimes : [TeetimeData class],
             kCourseUpdatesList : [CourseUpdate class],
             kGetDetailCommentsOnThread : [Post class],
             };
    
}                      
@end
