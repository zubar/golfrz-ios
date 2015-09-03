//
//  EventAdminViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/29/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "EventAdminViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "UIImageView+RoundedImage.h"
#import "CourseServices.h"
#import "Coordinate.h"
#import "Utilities.h"
#import "Constants.h"
#import "Course.h"
#import <CoreText/CoreText.h>
@interface EventAdminViewController ()

- (void)viewMapSelected;

@end

@implementation EventAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addGestureAdminContact];
    [self addGestureToAdminEmail];

    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];


    
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    
    [imageButton addTarget:self action:@selector(eventAdminBackBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewMapSelected)];
    [self.lblViewMap addGestureRecognizer:tapGesture];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.navigationItem.title = @"CONTACT ADMIN";
    
    [self loadDataForCurrentEvent];
}


-(void)loadDataForCurrentEvent{
   
    
    [self.imgEventLogo sd_setImageWithURL:[NSURL URLWithString:[[SharedManager sharedInstance] logoImagePath]] placeholderImage:[UIImage imageNamed:@"event_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgEventLogo setRoundedImage:image];
        }
    }];
    Course * mCourse = [CourseServices currentCourse];
    
    [self.lblEventName setText:self.currentEvent.name];
    [self.lblCourseName setText:[mCourse courseName]];
    [self.lblStreetAddress setText:[mCourse courseAddress]];
    [self.lblState setText:[mCourse courseState]];
    [self.lblCity setText:[mCourse courseCity]];
    [self.lblPostalCode setText:[[mCourse postalCode] stringValue]];
    [self.lblEventLocation setText:[self.currentEvent location]];
    
    
    [Utilities dateComponentsFromNSDate:[self.currentEvent dateStart] components:^(NSString *dayName, NSString *monthName, NSString *day, NSString *time, NSString *minutes, NSString * timeAndMinutes) {
        [self.lblDay setText:[NSString stringWithFormat:@"%@ %@", day, monthName]];
        [self.lblTime setText:timeAndMinutes];
    }];
    
    //TODO: JSON does don't contain image property for event admin, however the mock-up view does, so we will use it future, when imagePath is added
    // in JSON.
    [self.imgAdminPic sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imgAdminPic setRoundedImage:image];
        }
    }];
    
    EventAdmin * admin = [self.currentEvent eventAdmin];
    [self.lblAdminName setText:[NSString stringWithFormat:@"%@ %@", [admin firstName], [admin lastName]]];
    [self.lblAdminPost setText:[admin designation]];
   
    
    NSDictionary *contactAttributes =@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                       NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:14.0],
                                       NSForegroundColorAttributeName : [UIColor whiteColor]
                                       };
    
    NSAttributedString * adminPhone  = [[NSAttributedString alloc] initWithString:[admin phoneNo] attributes:contactAttributes];
    NSAttributedString * adminEmail  = [[NSAttributedString alloc] initWithString:[admin email] attributes:contactAttributes];
    
    [self.lblEmail setAttributedText:adminEmail];
    [self.lblContactNo setAttributedText:adminPhone];
}

- (void)viewMapSelected {
    [Utilities viewMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)eventAdminBackBtnTapped{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void) addGestureToAdminEmail{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adminEmailTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblEmail setUserInteractionEnabled:YES];
    [self.lblEmail addGestureRecognizer:gesture];
}


-(void) addGestureAdminContact{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adminContactTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.lblContactNo setUserInteractionEnabled:YES];
    [self.lblContactNo addGestureRecognizer:gesture];
}

-(void) adminEmailTapped{
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", (NSString *)self.lblEmail.text]]];
        
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:kError message:EmailSupportErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil];
        [notPermitted show];
    }
    
}

-(void) adminContactTapped{
    
    NSString *contact = (NSString *)self.lblContactNo.text;
    NSString *condensedPhoneno = [[contact componentsSeparatedByCharactersInSet:
                                   [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"]
                                    invertedSet]]
                                  componentsJoinedByString:@""];
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]) {
        if (contact.length) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", condensedPhoneno]]];
        }
        else {
            UIAlertView *notAvaliable=[[UIAlertView alloc] initWithTitle:kError message:NumberNotAvaliableErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil];
            [notAvaliable show];
        }
        
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:kError message:CallSupportErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil];
        [notPermitted show];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
