//
//  ContactServices.m
//  GolfersProject
//
//  Created by Zubair on 6/15/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ContactServices.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>
#import "APAddressBook.h"
#import <APAddressBook/APContact.h>
#import "Constants.h"
#import "UserServices.h"

@implementation ContactServices
static     APAddressBook *addressBook;

+(void)getAddressbookContactsFiltered:(ContactFilterOption )property
                         sortedByName:(BOOL)yesNo success:(void (^)(bool status, NSArray * contactsArray))successBlock
                              failure:(void (^)(bool status, NSError * error))failureBlock{
    
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        addressBook = [[APAddressBook alloc] init];
    });
    
    // Setting which properties are needed. 
    [addressBook setFieldsMask: APContactFieldRecordID | APContactFieldEmails | APContactFieldPhones | APContactFieldFirstName | APContactFieldLastName];
    
    // Setting filter
    if (property == ContactFilterEmail) {
        addressBook.filterBlock = ^BOOL(APContact *contact){
            return contact.emails.count > 0;
        };
    }else
        if (property == ContactFilterPhoneNumber) {
            addressBook.filterBlock = ^BOOL(APContact *contact){
                return contact.phones.count > 0;
            };
        }
    
    if (yesNo) {
        addressBook.sortDescriptors = @[
                                        [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
                                        [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]
                                        ];
    }
    
    [addressBook loadContacts:^(NSArray *contacts, NSError *error){
        if (!error){
            successBlock(true, contacts);
        }else{
            failureBlock(false, error);
        }
    }];
}


+(void)inviteContactViaEmail:(id)contact success:(void (^)(bool status, id response))successBlock failure:(void (^)(bool status, NSError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kSignInURL parameters:[ContactServices paramsInviteContactViaEmail] success:^(NSURLSessionDataTask *task, id responseObject) {
        //TODO: check success_messsage. 
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
    
    
}



//Call this method on contacts
+(void)startObservingAddressbookChangesCallback:(void (^)(void))callBack{
    // start observing
    [addressBook startObserveChangesWithCallback:^
     {
         callBack();
     }];

}

+(void)stopObservingAddressbookChanges{
    // stop observing
    [addressBook stopObserveChanges];
}

#pragma mark - HelperMethods 
+(NSDictionary *)paramsInviteContactViaEmail{
    
    return @{
             @"app_bundle_id": kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken]
             };
}

@end
