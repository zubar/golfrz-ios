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
#import "FaceBookAuthAgent.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "UtilityServices.h"

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
    [addressBook setFieldsMask: APContactFieldRecordID | APContactFieldEmails | APContactFieldPhones | APContactFieldFirstName | APContactFieldLastName | APContactFieldThumbnail];
    
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

/*
 Facebook has updated its privacy policy and now the graph api does not allow to get user's friend list. 
 So this method is not used At-all. Will remove it in next version.
 */
+(void)getFacebookFriendsFiltered:(ContactFilterOption)filterProperty
                     sortedbyName:(BOOL)yesNo
                          success:(void (^)(bool status, NSArray * friendsArray))successBlock
                          failure:(void (^)(bool status, NSError * error))failureBlock
{

    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends"
                                                                   parameters:nil];
    
    if ([FaceBookAuthAgent hasValidToken]) {
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                successBlock(true, result[@"data"]);
            }else{
                failureBlock(false, error);
            }
        }];
    }else{
        [FaceBookAuthAgent signInWithFacebook:^(bool status, NSDictionary *userInfo) {
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    //TODO: parse friends
                    successBlock(true, nil);
                }else{
                    failureBlock(false, error);
                }
            }];
        } failure:^(bool status, NSError *error) {
            // authentication failed
            failureBlock(false, error);
        }];
    }
}

//Future Use:
+(void)getInAppFriendsFiltered:(ContactFilterOption)filterProperty
                  sortedbyName:(BOOL)yesNo
                       success:(void(^)(bool status, NSArray * contactsArray))successBlock
                       failure:(void(^)(bool status, NSError * error))failureBlock
{
    
 
}



+(void)inviteContactViaEmail:(id)contact success:(void (^)(bool status, id response))successBlock
                     failure:(void (^)(bool status, NSError * error))failureBlock{
    
    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kSignInURL parameters:[ContactServices paramsInviteContactViaEmail] success:^(NSURLSessionDataTask *task, id responseObject) {
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
    
    return [UtilityServices authenticationParams];
}

@end
