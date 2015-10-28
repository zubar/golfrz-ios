
//
//  NSMutableArray+convenience.m
//
//  Created by in 't Veen Tjeerd on 5/10/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "User+convenience.h"
#import <objc/runtime.h>
#import "User.h"
#import <APContact.h>

@implementation User (Convenience)
@dynamic associatedObject;


- (NSString *)contactFirstName;
{
    return self.firstName;
}

-(NSString *)contactFullName{
    NSString * fullName = [NSString stringWithFormat:@"%@ %@", (self.firstName != nil ? self.firstName : @""), (self.lastName != nil ? self.lastName : @"")];
    return fullName;
}

-(NSString *)contactLastName{
    return self.lastName;
}

-(NSString *)contactPhoneNumber{
    
    if ([self isKindOfClass:[User class]]) {
        return nil;
    }
//    else
//        if ([self.phones firstObject]) {
//                return [self.phones firstObject];
//    }
    return @"+00 000 0000000";
}

-(NSString *)contactEmail{
    if (self.email) {
        return self.email;
    }
    return @"User did not added email.";
}

//In future will allow user to upload his image to server. 
-(UIImage *)contactImage{
    return nil;
}

- (void)setAssociatedObject:(id)object {
    objc_setAssociatedObject(self, @selector(associatedObject), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedObject {
    return objc_getAssociatedObject(self, @selector(associatedObject));
}


@end
