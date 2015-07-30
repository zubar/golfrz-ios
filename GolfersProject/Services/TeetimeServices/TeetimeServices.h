//
//  TeetimeServices.h
//  GolfersProject
//
//  Created by Zubair on 7/30/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TeetimeData;
@class GolfrzError;

@interface TeetimeServices : NSObject

+(void)getTeetimesForSubcourse:(NSNumber *)subcourseId
                       success:(void(^)(bool status, TeetimeData * dataTees ))successBlock
                       failure:(void (^)(bool status, GolfrzError * error))failureBlock;
@end
