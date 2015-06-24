//
//  SharedManager.h
//  GolfersProject
//
//  Created by Zubair on 6/1/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface SharedManager : NSObject<CLLocationManagerDelegate>{
    CLLocationManager * sharedLocationManager;
}

@property (strong, nonatomic) UIColor * themeColor;
@property (strong, nonatomic) NSString * backgroundImagePath;
@property (strong, nonatomic) NSString * logoImagePath;
@property (strong, nonatomic) NSString * courseState;
@property (strong, nonatomic) NSString * courseCity;
@property (strong, nonatomic) NSString * courseName;

@property (assign, nonatomic) NSUInteger cartBadgeCount;

+ (SharedManager *)sharedInstance;
-(BOOL)isUserLocationInCourse;

-(void)updateCartItemsCountCompletion:(void(^)(void))completion;
@end
