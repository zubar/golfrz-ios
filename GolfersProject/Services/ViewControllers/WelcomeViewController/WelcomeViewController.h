//
//  GreenViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClubHouseSubController.h"
#import "SharedManager.h"
#import "WEPopoverController.h"

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer(UIColor)

// This assigns a CGColor to borderColor.
@property(nonatomic, assign) UIColor* borderUIColor;

@end

@interface WelcomeViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, SharedManagerDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate
>
@property (strong, nonatomic) IBOutlet UICollectionView *weatherCollectionView;
@property (strong, nonatomic) IBOutlet UIImageView *imgCourseLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblCourseName;
@property (weak, nonatomic) IBOutlet UILabel *lblCourseCityState;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;

/**
 *
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;
@property (strong, nonatomic) IBOutlet UILabel *lblWeatherDate;

/*
 *
 */
- (IBAction)btnMemberLoginTap:(id)sender;
- (IBAction)btnEventsCalendarTap:(id)sender;
- (IBAction)btnContactUsTap:(id)sender;


@end
