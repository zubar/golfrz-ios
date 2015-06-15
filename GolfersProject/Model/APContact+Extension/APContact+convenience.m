
//
//  NSMutableArray+convenience.m
//
//  Created by in 't Veen Tjeerd on 5/10/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "APContact+convenience.h"

@implementation APContact (Convenience)

- (NSString *)cfirstName;
{
    return self.firstName;
}

-(NSString *)lastName{
    return self.lastName;
}

-(NSString *)phoneNumber{
    if ([self.phones firstObject]) {
        return [self.phones firstObject];
    }
    return @"+00 000 0000000";
}

-(NSString *)email{
    if ([self.emails firstObject]) {
        return [self.emails firstObject];
    }
    return @"no email exists";
}

@end
