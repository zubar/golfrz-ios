//
//  Weather.h
//  GolfersProject
//
//  Created by Zubair on 5/21/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "Condition.h"


@interface WeatherData : NSObject

@property (retain, nonatomic ) NSNumber * temperature;   //kelvin
@property (retain, nonatomic ) NSNumber * minimumTemperature;
@property (retain, nonatomic ) NSNumber * maximumTemperature;
@property (retain, nonatomic ) NSNumber * atmosphericPressure;
@property (retain, nonatomic ) NSNumber * seaLevel;
@property (retain, nonatomic ) NSNumber * groundLevel; //unit: hpa
@property (retain, nonatomic ) NSNumber * humidity;
@property (retain, nonatomic ) NSNumber * temp_kf;
@property (retain, nonatomic ) NSString * stringDate;

@property (retain, nonatomic) Condition * condition;

+(WeatherData *)initWithDictionary:(NSDictionary *)weatherData;

@end
