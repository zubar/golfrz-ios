//
//  FoodBeverageServices.h
//  GolfersProject
//
//  Created by Zubair on 6/9/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Menu;
@class FoodBeverage;

@interface FoodBeverageServices : NSObject

+(void)getMenu:(void (^)(bool status, Menu * currentMenu))successBlock
       failure:(void (^)(bool status, NSError * error))failureBlock;


/*
+(void)addItemToCart:(FoodBeverage *)item;
+(void)removeItemFromCart:(FoodBeverage *)item;
+(NSArray *)cartItemsList;
*/
@end
