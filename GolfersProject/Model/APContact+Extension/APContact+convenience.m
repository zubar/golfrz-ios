
//
//  NSMutableArray+convenience.m
//
//  Created by in 't Veen Tjeerd on 5/10/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "APContact+convenience.h"

@implementation APContact (Convenience)

- (NSString *)contactFirstName;
{
    return self.firstName;
}

-(NSString *)contactLastName{
    return self.lastName;
}

-(NSString *)contactPhoneNumber{
    if ([self.phones firstObject]) {
        return [self.phones firstObject];
    }
    return @"+00 000 0000000";
}

-(NSString *)contactEmail{
    if ([self.emails firstObject]) {
        return [self.emails firstObject];
    }
    return @"no email exists";
}

-(NSString *)contactImageURL{
    //TODO: 
return @"";
}

@end
