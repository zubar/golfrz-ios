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
@class Order;
@class Cart;

@interface FoodBeverageServices : NSObject

+(void)getMenu:(void (^)(bool status, Menu * currentMenu))successBlock
       failure:(void (^)(bool status, NSError * error))failureBlock;

+(void)addItemToCart:(FoodBeverage *)item
            quantity:(NSUInteger )quantity
           withBlock:(void (^)(bool status, NSDictionary * response))successBlock
             failure:(void (^)(bool status, NSError * error))failureBlock;


+(void)removeItemFromCart:(Order *)item
                withBlock:(void (^)(bool status, NSDictionary * response))successBlock
                  failure:(void (^)(bool status, NSError * error))failureBlock;

+(void)cartItemsForCurrentUser:(void (^)(bool status, Cart * response))successBlock
                       failure:(void (^)(bool status, NSError * error))failureBlock;
    

+(void)addItemsToCartWithIds:(NSArray *)items
                    quantity:(NSUInteger )quantity
                   withBlock:(void (^)(bool status, NSDictionary * response))successBlock
                     failure:(void (^)(bool status, NSError * error))failureBlock;
/*
+(void)addItemToCart:(FoodBeverage *)item;
+(void)removeItemFromCart:(FoodBeverage *)item;
+(NSArray *)cartItemsList;
*/
@end
