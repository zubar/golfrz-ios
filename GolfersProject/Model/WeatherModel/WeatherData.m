//
//  Weather.m
//  GolfersProject
//
//  Created by Zubair on 5/21/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "WeatherData.h"
#import "NSDate+Helper.h"

@implementation WeatherData

+(WeatherData *)initWithDictionary:(NSDictionary *)weatherData{
    
    WeatherData * weatherObject = [[WeatherData alloc]init];
    weatherObject.temperature = weatherData[@"temp"];
    weatherObject.minimumTemperature = weatherData[@"temp_min"];
    weatherObject.maximumTemperature = weatherData[@"temp_max"];
    weatherObject.groundLevel = weatherData[@"grnd_level"];
    weatherObject.humidity = weatherData[@"humidity"];
    weatherObject.atmosphericPressure = weatherData[@"pressure"];
    weatherObject.temp_kf = weatherData[@"temp_kf"];
   // weatherObject.stringDate = weatherData[@"dt_txt"];
   // weatherObject.timeStamp = [NSDate dateFromString:weatherObject.stringDate];
    
    return weatherObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}


/*
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"temperature" : @"temp",
             @"minimumTemperature" : @"temp_min",
             @"maximumTemperature" : @"temp_max",
             @"atmosphericPressure": @"pressure",
             @"seaLevel" : @"sea_level",
             @"groundLevel" : @"grnd_level",
             @"humidity" : @"humidity",
             @"temp_kf" : @"tmep_kf"
             //propertyName : json_key
             };
}

+ (NSArray *)deserializeAppInfosFromJSON:(NSArray *)appInfosJSON
{
    NSError *error;
    NSArray *appInfos = [MTLJSONAdapter modelsOfClass:[WeatherData class] fromJSONArray:appInfosJSON error:&error];
    if (error) {
        NSLog(@"Couldn't convert app infos JSON to ChoosyAppInfo models: %@", error);
        return nil;
    }
    
    return appInfos;
}
*/
@end
