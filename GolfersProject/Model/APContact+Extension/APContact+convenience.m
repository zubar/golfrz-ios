
//
//  NSMutableArray+convenience.m
//
//  Created by in 't Veen Tjeerd on 5/10/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "APContact+convenience.h"
#import <objc/runtime.h>


@implementation APContact (Convenience)
@dynamic associatedObject;


- (NSString *)contactFirstName;
{
    return self.firstName;
}

-(NSString *)contactLastName{
    return self.lastName;
}

-(NSString *)contactPhoneNumber{
    if ([self.phones firstObject]) {
        NSMutableString * phoneNum = [[self.phones firstObject] mutableCopy];
        NSString * phoneNoWhiteSpace = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
        return phoneNoWhiteSpace;
    }
    return @"+000000000000";
}

-(NSString *)contactEmail{
    if ([self.emails firstObject]) {
        return [self.emails firstObject];
    }
    return @"no email exists";
}

-(UIImage *)contactImage{
    return self.thumbnail;
}

- (void)setAssociatedObject:(id)object {
    objc_setAssociatedObject(self, @selector(associatedObject), object, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)associatedObject {
    return objc_getAssociatedObject(self, @selector(associatedObject));
}


@end
