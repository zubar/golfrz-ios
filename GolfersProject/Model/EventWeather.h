//
//  EventWeather.h
//  GolfersProject
//
//  Created by Zubair on 6/2/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventWeather : NSObject

@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSDate * timeStamp;

@end
