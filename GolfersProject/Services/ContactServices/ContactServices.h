//
//  ContactServices.h
//  GolfersProject
//
//  Created by Zubair on 6/15/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    ContactFilterEmail,
    ContactFilterPhoneNumber
} ContactFilterOption;


@interface ContactServices : NSObject

+(void)getAddressbookContactsFiltered:(ContactFilterOption )property
                         sortedByName:(BOOL)yesNo success:(void (^)(bool status, NSArray * contactsArray))successBlock
                              failure:(void (^)(bool status, NSError * error))failureBlock;

@end
