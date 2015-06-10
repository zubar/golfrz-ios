//
//  FoodBeverageServices.h
//  GolfersProject
//
//  Created by Zubair on 6/9/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Menu;

@interface FoodBeverageServices : NSObject

+(void)getMenu:(void (^)(bool status, Menu * currentMenu))successBlock
       failure:(void (^)(bool status, NSError * error))failureBlock;

@end
