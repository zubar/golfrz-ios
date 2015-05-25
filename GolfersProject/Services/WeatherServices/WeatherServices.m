//
//  WeatherServices.m
//  GolfersProject
//
//  Created by Zubair on 5/21/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "WeatherServices.h"
#import "WeatherData.h"
#import "Condition.h"
#import "APIClient.h"
#import "NSDate+Helper.h"
#import "Constants.h"
#import "Course.h"
#import "Coordinates.h"

#import "CourseServices.h"

@implementation WeatherServices


+(void)weatherInfo:(void (^)(bool status, NSArray * mWeatherData))successBlock failure:(void (^)(bool status, NSError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kWeatherAPI]];
    NSDictionary * coordinates = [WeatherServices coordinatesForCurrentCourse];
    
    NSString * endPoint =[NSString stringWithFormat:@"forecast?lat=%@&lon=%@&units=metric&APPID=%@", coordinates[@"latitude"], coordinates[@"longitude"], kWeatherAPIKey];
    
    
    [apiClient GET:endPoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       
        NSArray * tempObjects = [(NSDictionary *)responseObject objectForKey:@"list"];
        NSMutableArray * weatherObjects = [[NSMutableArray alloc]initWithCapacity:tempObjects.count];
        
        
        for (NSDictionary * weather in tempObjects) {
            WeatherData * temp = [WeatherData initWithDictionary:weather[@"main"]];
            temp.stringDate = weather[@"dt_txt"];
            temp.timeStamp = [NSDate dateFromString:temp.stringDate];

            Condition * tempCondition = [Condition initWithDictionary:weather[@"weather"][0]];
            [temp setCondition:tempCondition];
            
            [weatherObjects addObject:temp];
        }
        successBlock(true, weatherObjects);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}



+(NSDictionary *)coordinatesForCurrentCourse{
    if ([CourseServices currentCourse]) {
        Coordinates * mCourse = [[CourseServices currentCourse].coordinates objectAtIndex:0];
        return  @{
                  @"latitude" : mCourse.latitude,
                  @"longitude" : mCourse.longitude
                  };
    }else
    return @{
             @"latitude" : @"0",
             @"longitude" : @"0"
             };
}



@end
