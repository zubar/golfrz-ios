//
//  WeatherServices.h
//  GolfersProject
//
//  Created by Zubair on 5/21/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"

@interface WeatherServices : NSObject

+(void)weatherInfo:(void (^)(bool status, NSArray * mWeatherData))successBlock
           failure:(void (^)(bool status, NSError * error))failureBlock;

+(void)dailyWeather:(void(^)(bool status, NSDictionary * weatherData))successBlock
            failure:(void (^)(bool status, NSError * error))failureBlock;

@end
