//
//  EventAdmin.h
//  GolfersProject
//
//  Created by Zubair on 6/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLModel.h"

@interface EventAdmin :  MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber * adminId;
@property (copy, nonatomic, readonly) NSString * email;

@property (copy, nonatomic, readonly) NSString * firstName;
@property (copy, nonatomic, readonly) NSString * lastName;

@property (copy, nonatomic, readonly) NSString * userName;
@property (copy, nonatomic, readonly) NSNumber * memberId;
@property (copy, nonatomic, readonly) NSNumber * handicap;

@property (copy, nonatomic, readonly) NSString * phoneNo;
@property (copy, nonatomic, readonly) NSString * role;


@property (copy, nonatomic, readonly) NSDate * dateStart;
@property (copy, nonatomic, readonly) NSDate * dateEnd;

@end







"id": 6,
"email": "course_pro_shot_admin@golfrz.com",
"first_name": "course_pro_shot_admin",
"last_name": null,
"username": "course_pro_shot_admin",
"member_id": null,
"handicap": null,
"phone_no": null,
"token": "lECWgt7gZLuiCVqDY6fWoK14nABtrKJ0luideYrih48=",
"course_role": "course_pro_shot_admin"