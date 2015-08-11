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
#import "GolfrzError.h"

@implementation FoodBeverageServices

+(void)getMenu:(void (^)(bool status, Menu * currentMenu))successBlock
       failure:(void (^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kFoodAndBeverage parameters:[FoodBeverageServices userAuthParams] completion:^(id response, NSError *error) {
            OVCResponse * resp = response;
            if (!error) {
                Menu * tMenu = [resp result];
                successBlock(true, tMenu);
            }else
                failureBlock(false, [response result]);
        }];
}
+(void)addItemToCart:(FoodBeverage *)item
            quantity:(NSUInteger )quantity
           withBlock:(void (^)(bool status, NSDictionary * response))successBlock
             failure:(void (^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient POST:kAddItemToCart parameters:[FoodBeverageServices paramsForCartItem:item quantity:quantity]
         completion:^(id response, NSError *error) {
             if (!error) {
                 if ((NSDictionary *)[response result][@"success_message"] ) {
                     successBlock(true, [response result]);
                 }
             }else{
                 failureBlock(false, [response result]);
             }
    }];
}

+(void)addItemsToCartWithIds:(NSArray *)items
            quantity:(NSUInteger )quantity
           withBlock:(void (^)(bool status, NSDictionary * response))successBlock
             failure:(void (^)(bool status, GolfrzError * error))failureBlock{
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient POST:kAddItemToCart parameters:[FoodBeverageServices paramsForItemIds:items quantity:quantity] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            if ((NSDictionary *)resp.result[@"success_message"] ) {
                successBlock(true, [response result]);
            }
        }else{
            failureBlock(false, [response result]);
        }
    }];
}

+(void)removeItemFromCart:(Order *)item
                withBlock:(void (^)(bool status, NSDictionary * response))successBlock
                  failure:(void (^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient POST:kRemoveFromCart parameters:[FoodBeverageServices paramsForRemoveCartItem:item] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if ((NSDictionary *)resp.result[@"success_message"] ) {
            successBlock(true, resp.result);
        }else{
            failureBlock(false, [resp result]);
        }
    }];
}

+(void)cartItemsForCurrentUser:(void (^)(bool status, Cart * response))successBlock
                       failure:(void (^)(bool status, GolfrzError * error))failureBlock
{
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kViewCart parameters:[FoodBeverageServices userAuthParams] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if(!error){
            if ([resp result]) {
                Cart * tempCart = [resp result];
                successBlock(true, tempCart);
            }
        }else{
            failureBlock(false, [resp result]);
        }
    }];
}


+(void)confirmOrderWithLocation:(NSString *)deliveryLocation
                        success:(void (^)(bool status, NSString * response))successBlock
                        failure:(void (^)(bool status, GolfrzError * error))failureBlock
{
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient POST:kConfirmCartOrder parameters:[FoodBeverageServices confirmOrderParams:deliveryLocation] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error){
            successBlock(true, [resp result]);
    }else{
        failureBlock(false, [resp result]);
    }
    }];
}

#pragma mark - Helper Methods


+(NSDictionary *)userAuthParams
{
    return @{@"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken]
             };
}

+(NSDictionary *)confirmOrderParams:(NSString *)place
{
    return @{@"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"location" : place
             };
}
+(NSDictionary *)paramsForCartItem:(FoodBeverage *)item quantity:(NSUInteger)quantity
{
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
+(NSDictionary *)paramsForItemIds:(NSArray *)items quantity:(NSUInteger)quantity
{
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"menu_item_ids" : [items componentsJoinedByString:@","],
             @"quantity" : [NSNumber numberWithInteger:quantity]
             };
}
+(NSDictionary *)paramsForRemoveCartItem:(Order *)order
{
    return @{@"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"order_id" : [order orderId]
             };
}
+(NSDictionary *)paramsForSubmitOrder
{
    return @{@"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"member_id" : [UserServices currentUserId]
             };
}

@end
