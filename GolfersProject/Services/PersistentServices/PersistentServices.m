//
//  PersistentServices.m
//  GolfersProject
//
//  Created by Zubair on 7/12/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PersistentServices.h"


#define fileName @"DataDict.dict"



@implementation PersistentServices


- (instancetype)init
{
    self = [super init];
    if (self) {
        dataDict = [[NSMutableDictionary alloc]initWithContentsOfFile:[self filePath]];
    }
    return self;
}

-(NSString *)currentUserToken{
  return  dataDict[@"currentUserToken"];
}

-(void)setCurrentUserToken:(NSString *)userToken{
    [dataDict setValue:userToken forKey:@"currentUserToken"];
}


-(NSString *)currentUserEmail{
    return  dataDict[@"currentUserEmail"];
}

-(void)setCurrentUserEmail:(NSString *)email{
    [dataDict setValue:email forKey:@"currentUserEmail"];
}


-(NSString *)filePath{
    return [NSString stringWithFormat:@"%@%@", [self applicationDocumentsDirectory], fileName];
}

-(NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(void)writeDataToFile{
    [dataDict writeToFile:[self filePath] atomically:YES];
}





@end
