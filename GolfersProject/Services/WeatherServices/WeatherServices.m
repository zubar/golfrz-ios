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

@implementation WeatherServices


+(void)weatherInfo:(void (^)(bool status, NSArray * mWeatherData))successBlock failure:(void (^)(bool status, NSError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.openweathermap.org"]];

    NSString * endPoint = @"/data/2.5/forecast?lat=31&lon=139&units=metric&APPID=e5bfb7faf3d0c719e87f3e1300ad0739";
    
    
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


/*
-(NSDictionary *)paramsForCityName:(NSString *)cityName state:(NSString *)stateName{


}
*/


@end
