//
//  GreenViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ClubHouseViewController.h"
#import "ClubHouseContainerVC.h"
#import "WeatherViewCell.h"
#import "WeatherServices.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"


@interface ClubHouseViewController ()
@property (nonatomic, retain) NSArray * weatherList;
@end

@implementation ClubHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Clubhouse"];
    
    // Do any additional setup after loading the view.
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [WeatherServices weatherInfo:^(bool status, NSArray *mWeatherData) {
        if (status) {
            self.weatherList = mWeatherData;
            [self.weatherCollectionView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(bool status, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[[UIAlertView alloc]initWithTitle:@"Try Again" message:@"Failed to get weather" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil] show];
        }
    }];
}

- (void)pushNextController{
    [self.navigationController pushViewController:self.containerVC.playerProfileViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.weatherList count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeatherCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    WeatherData * tempWeather = [self.weatherList objectAtIndex:indexPath.row];
    
    NSLog(@"%@", tempWeather.condition.icon);
    
    WeatherViewCell *customCell = (WeatherViewCell *)cell;
    [customCell.lblTime setText:[self hoursFromDate:tempWeather.timeStamp]];
    [customCell.lblTemperature setText:[NSString stringWithFormat:@"%@", tempWeather.temperature]];
    
    [customCell.imgWeatherIcon sd_setImageWithURL:[NSURL URLWithString:tempWeather.condition.icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      //  <#code#>
        [customCell.imgWeatherIcon setImage:image];
    } ];
    
    
    return customCell;
}

-(NSString *)hoursFromDate:(NSDate *)date{

//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"<your date format goes here"];
//    NSDate *date = date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    return [NSString stringWithFormat:@"%ld", (long)hour];
}


-(void)btnTapped{

    NSLog(@"Tapped Green");
}

#pragma mark - NavBarButtonsDelegate


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
