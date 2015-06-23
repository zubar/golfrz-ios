//
//  NSMutableArray+convenience.h
//
//  Created by in 't Veen Tjeerd on 5/10/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <APAddressBook/APContact.h>


@interface APContact (Convenience)

- (NSString *)contactFirstName;
- (NSString *)contactLastName;
- (NSString *)contactPhoneNumber;
- (NSString *)contactEmail;
- (UIImage *)contactImage;

@property (nonatomic, strong) NSNumber * associatedObject;


@end
