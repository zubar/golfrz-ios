//
//  CalendarEvent.h
//  GolfersProject
//
//  Created by Zubair on 5/26/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLModel.h"
#import "EventAdmin.h"

@interface CalendarEvent : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber * eventId;
@property (copy, nonatomic, readonly) NSNumber * courseId;

@property (copy, nonatomic, readonly) NSDate * dateStart;
@property (copy, nonatomic, readonly) NSDate * dateEnd;

@property (copy, nonatomic, readonly) NSString * breif;
@property (copy, nonatomic, readonly) NSString * name;
@property (copy, nonatomic, readonly) NSString * eventType; //TODO: define enum for it.
@property (copy, nonatomic, readonly) NSString * location;
@property (copy, nonatomic, readonly) NSString * summary;

@property (copy, nonatomic, readonly) NSString * imagePath;

@property (copy, nonatomic, readonly) EventAdmin * eventAdmin;

@end
