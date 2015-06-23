//
//  FoodBeverageServices.m
//  GolfersProject
//
//  Created by Zubair on 6/9/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "FoodBeverageServices.h"
#import "Constants.h"
#import "UserServices.h"
#import "APIClient.h"
#import "Menu.h"
#import "FoodBeverage.h"
#import "SharedManager.h"
#import "UtilityServices.h"
#import "Order.h"
#import "UserServices.h"
#import "Cart.h"

@implementation FoodBeverageServices



+(void)getMenu:(void (^)(bool status, Menu * currentMenu))successBlock
       failure:(void (^)(bool status, NSError * error))failureBlock{
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kFoodAndBeverage
        parameters:[FoodBeverageServices userAuthParams]
        completion:^(id response, NSError *error) {
            
            OVCResponse * resp = response;
            if (!error) {
                Menu * tMenu = [resp result];
                successBlock(true, tMenu);
            }else
                failureBlock(false, error);
        }];
    
}


+(void)addItemToCart:(FoodBeverage *)item
            quantity:(NSUInteger )quantity
           withBlock:(void (^)(bool status, NSDictionary * response))successBlock
             failure:(void (^)(bool status, NSError * error))failureBlock{

    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient POST:kAddItemToCart
         parameters:[FoodBeverageServices paramsForCartItem:item quantity:quantity]
            success:^(NSURLSessionDataTask *task, id responseObject) {
                
                if ((NSDictionary *)responseObject[@"success_message"] ) {
                    successBlock(true, responseObject);
                }
            }failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (error) {
                    failureBlock(false, error);
                }else{
                    failureBlock(false, [NSError errorWithDomain:@"ios-app" code:0 userInfo:@{@"error_message":@"Un-known"}]);
                }
            }];
}

+(void)addItemsToCartWithIds:(NSArray *)items
            quantity:(NSUInteger )quantity
           withBlock:(void (^)(bool status, NSDictionary * response))successBlock
             failure:(void (^)(bool status, NSError * error))failureBlock{
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient POST:kAddItemToCart
         parameters:[FoodBeverageServices paramsForItemIds:items quantity:quantity]
            success:^(NSURLSessionDataTask *task, id responseObject) {
                
                OVCResponse * resp = responseObject;
                if ((NSDictionary *)resp.result[@"success_message"] ) {
                    successBlock(true, responseObject);
                }
            }failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (error) {
                    failureBlock(false, error);
                }else{
                    failureBlock(false, [NSError errorWithDomain:@"ios-app" code:0 userInfo:@{@"error_message":@"Un-known"}]);
                }
            }];
}



+(void)removeItemFromCart:(Order *)item
                withBlock:(void (^)(bool status, NSDictionary * response))successBlock
                  failure:(void (^)(bool status, NSError * error))failureBlock{
    
    
    APIClient * apiClient = [APIClient sharedAPICLient];
   [apiClient POST:kRemoveFromCart
        parameters:[FoodBeverageServices paramsForRemoveCartItem:item] success:^(NSURLSessionDataTask *task, id responseObject) {
       OVCResponse * resp = responseObject;
       if ((NSDictionary *)resp.result[@"success_message"] ) {
           successBlock(true, responseObject);
       }
   } failure:^(NSURLSessionDataTask *task, NSError *error) {
       if (error) {
           failureBlock(false, error);
       }else{
           failureBlock(false, [NSError errorWithDomain:@"ios-app" code:0 userInfo:@{@"error_message":@"Un-known"}]);
       }
   }];
     
}

+(void)cartItemsForCurrentUser:(void (^)(bool status, Cart * response))successBlock
                       failure:(void (^)(bool status, NSError * error))failureBlock{
    
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    
    [apiClient GET:kViewCart
        parameters:[FoodBeverageServices userAuthParams]
           success:^(NSURLSessionDataTask *task, id responseObject) {
               
               OVCResponse * resp = responseObject;
                    if ([resp result]) {
                        Cart * tempCart = [resp result];
                        successBlock(true, tempCart);
                    }
            }failure:^(NSURLSessionDataTask *task, NSError *error) {
                    if (error) {
                        failureBlock(false, error);
                    }else{
                        failureBlock(false, [NSError errorWithDomain:@"ios-app" code:0 userInfo:@{@"error_message":@"Un-known"}]);
                    }
           }];
}


+(void)confirmOrderWithLocation:(NSString *)deliveryLocation
                        success:(void (^)(bool status, NSString * response))successBlock
                       failure:(void (^)(bool status, NSError * error))failureBlock{
    
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    
    [apiClient POST:kConfirmCartOrder
         parameters:[FoodBeverageServices confirmOrderParams:deliveryLocation] success:^(NSURLSessionDataTask *task, id responseObject) {
             OVCResponse * resp = responseObject;
             if ((NSDictionary *)resp.result[@"success_message"] ) {
                 successBlock(true, responseObject);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if (error) {
                 failureBlock(false, error);
             }else{
                 failureBlock(false, [NSError errorWithDomain:@"ios-app" code:0 userInfo:@{@"error_message":@"Un-known"}]);
             }
         }];
}

/*
 
 +(void)addItemToCart:(FoodBeverage *)item{
 
 SharedManager * manager = [SharedManager sharedInstance];
 if (item && [item isKindOfClass:[FoodBeverage class]]) {
 [manager addItemInCart:item];
 }
 }
 
 +(void)removeItemFromCart:(FoodBeverage *)item{
 
 SharedManager * manager = [SharedManager sharedInstance];
 if (item && [item isKindOfClass:[FoodBeverage class]]) {
 [manager removeItemFromCart:item];
 }
 }
 
 +(NSArray *)cartItemsList{
 SharedManager * manager = [SharedManager sharedInstance];
 return [manager cartList];
 }

 */
#pragma mark - Helper Methods



+(NSDictionary *)userAuthParams{
    
    return @{@"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken]
             };
    
}

+(NSDictionary *)confirmOrderParams:(NSString *)place{
    
    return @{@"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"location" : place
             };
    
}


+(NSDictionary *)paramsForCartItem:(FoodBeverage *)item quantity:(NSUInteger)quantity{
   
    NSDictionary *foodItem = [MTLJSONAdapter JSONDictionaryFromModel:item];
    
    NSMutableArray * ids_arry = nil;
    if (foodItem[@"id"] && foodItem[@"menus_side_items"]) {
        ids_arry  =[[NSMutableArray alloc] initWithArray:[foodItem valueForKeyPath:@"sideItems.@distinctUnionOfObjects.foodId"]];
        [ids_arry addObject:foodItem[@"id"]];
    }
    
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"menu_item_ids" : ids_arry,
             @"quantity" : [NSNumber numberWithInteger:quantity]
             };
}


+(NSDictionary *)paramsForItemIds:(NSArray *)items quantity:(NSUInteger)quantity{
    
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"menu_item_ids" : [items componentsJoinedByString:@","],
             @"quantity" : [NSNumber numberWithInteger:quantity]
             };
}

+(NSDictionary *)paramsForRemoveCartItem:(Order *)order{
    
    return @{@"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"order_id" : [order orderId]
             };
}

+(NSDictionary *)paramsForSubmitOrder{
   
    
    return @{@"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"member_id" : [UserServices currentUserId]
             };
}

@end
