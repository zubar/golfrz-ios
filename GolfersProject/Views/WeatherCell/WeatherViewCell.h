//
//  WeatherViewCell.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/21/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgWeatherIcon;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTemperature;

@end
