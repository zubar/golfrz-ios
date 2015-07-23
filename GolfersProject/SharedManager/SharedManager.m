//
//  SharedManager.m
//  GolfersProject
//
//  Created by Zubair on 6/1/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "SharedManager.h"
#import "CourseServices.h"
#import "Course.h"
#import "Coordinate.h"
#import "FoodBeverageServices.h"
#import "Cart.h"
#import "Constants.h"


/*
 http://alienryderflex.com/polygon/
 According to georgian calendar
 
 Globals which should be set before calling this function:
 
 int    polyCorners  =  how many corners the polygon has (no repeats)
 float  polyX[]      =  horizontal coordinates of corners
 float  polyY[]      =  vertical coordinates of corners
 float  x, y         =  point to be tested
 
 (Globals are used in this example for purposes of speed.  Change as
 desired.)
 
 The function will return YES if the point x,y is inside the polygon, or
 NO if it is not.  If the point is exactly on the edge of the polygon,
 then the function may return YES or NO.
 
 Note that division by zero is avoided because the division is protected
 by the "if" clause which surrounds it.
 */

bool pointInPolygon(int polyCorners, float polyX[], float polyY[], float x, float y) {
    
    int   i, j=polyCorners-1 ;
    bool  oddNodes=NO      ;
    
    for (i=0; i<polyCorners; i++) {
        if (((polyY[i]< y && polyY[j]>=y)
             ||   (polyY[j]< y && polyY[i]>=y))
            &&  (polyX[i]<=x || polyX[j]<=x)) {
            if (polyX[i]+(y-polyY[i])/(polyY[j]-polyY[i])*(polyX[j]-polyX[i])<x) {
                oddNodes=!oddNodes; }}
        j=i; }
    
    return oddNodes;
}


@interface SharedManager (){
    CGPoint lastKnownLocation;
    NSMutableDictionary * dataDict;
}
@end

@implementation SharedManager


+ (SharedManager *)sharedInstance {
    
    static SharedManager *sharedInstance = nil;

    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[SharedManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        sharedLocationManager = [[CLLocationManager alloc]init];
        sharedLocationManager.delegate = self;
        sharedLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.cartBadgeCount = 0;
        
        dataDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}


-(BOOL)isUserLocationInCourse{
   
    // Check if location services are enabled if not  retun & TODO: show alert
    Course * mCourse = [CourseServices currentCourse];
    int polyCorners = (int)[mCourse.coordinates count];
    
    float polyX [polyCorners];
    float polyY [polyCorners];
    
    for ( int i = 0; i < [mCourse.coordinates count]; ++i) {
        Coordinate * mCord = mCourse.coordinates[i];
            polyX[i] = [mCord.longitude floatValue];
            polyY[i] = [mCord.latitude floatValue];
    }
    
    CGPoint currentCoordinates = [self currentLocationCordinates];
    
    return pointInPolygon(polyCorners, polyX, polyY, currentCoordinates.x, currentCoordinates.y);
}

-(void)updateCartItemsCountCompletion:(void(^)(void))completion{
    [FoodBeverageServices cartItemsForCurrentUser:^(bool status, Cart *response) {
        if(status)
            self.cartBadgeCount = [response.orders count];
        completion();
    } failure:^(bool status, NSError *error) {
        if (error)
            NSLog(@"can't update cart count");
    }];

}


#pragma mark - LocationHelper

-(CGPoint)currentLocationCordinates{
    return CGPointMake(lastKnownLocation.x, lastKnownLocation.y);
}

-(void)triggerLocationServices {
    
    if ([CLLocationManager locationServicesEnabled]) {
        if ([sharedLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [sharedLocationManager requestWhenInUseAuthorization];
            [self startUpdatingLocation];
        } else {
            [self startUpdatingLocation];
        }
    }
}

-(void)startUpdatingLocation{
    [sharedLocationManager startUpdatingLocation];
}

#pragma mark - CLLLocationManager
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
   [[[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    NSLog(@"Error: %@",error.description);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude: %+.6f\n, longitude: %+.6f\n, altitude: %+.6f\n, speed: %+.6f\n vertical_accuracy: %+.6f\n horizontal_accuracy: %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude,
              location.altitude,
              location.speed,
              location.verticalAccuracy,
              location.horizontalAccuracy);
        if ((location.verticalAccuracy <= kAccuracyGPS ) && (location.horizontalAccuracy <= kAccuracyGPS)) {
            lastKnownLocation.x = location.coordinate.longitude;
            lastKnownLocation.y = location.coordinate.latitude;
            [sharedLocationManager stopUpdatingLocation];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(IsUserInCourseWithRequiredAccuracy:)]){
                ([self isUserLocationInCourse] ?
                 [self.delegate IsUserInCourseWithRequiredAccuracy:YES] : [self.delegate IsUserInCourseWithRequiredAccuracy:NO]);
            }
        }
    }
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorized) {
        [self startUpdatingLocation];
    }
}


#pragma mark - Manage Invitation
-(BOOL )isInvitationAccepted{
    return [dataDict[@"invitationStatus"] boolValue];
}

-(void)setInvitationStatusAccepted:(BOOL )waitingStatus{
    [dataDict setObject:[NSNumber numberWithBool:waitingStatus] forKey:@"invitationStatus"];
}

-(NSString *)invitationToken{
    return dataDict[@"invitationToken"];
}

-(void)setInvitationToken:(NSString *)token{
    [dataDict setObject:token forKey:@"invitationToken"];
}

@end
