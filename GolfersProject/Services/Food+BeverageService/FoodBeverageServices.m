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

@implementation FoodBeverageServices



+(void)getMenu:(void (^)(bool status, Menu * currentMenu))successBlock failure:(void (^)(bool status, NSError * error))failureBlock{
    
    APIClient * apiClient = [APIClient sharedAPICLient];
    [apiClient GET:kFoodAndBeverage parameters:[FoodBeverageServices paramsForItemList] completion:^(id response, NSError *error) {
        OVCResponse * resp = response;
        if (!error) {
            Menu * tMenu = [resp result];
            successBlock(true, tMenu);
        }else
            failureBlock(false, error);
    }];
    
}


+(void)addItemsToCart:(NSArray *)arrayOfiTems  quantity:(NSUInteger )quantity withBlock:(void (^)(bool status, Menu * currentMenu))successBlock failure:(void (^)(bool status, NSError * error))failureBlock{

    AFHTTPSessionManager * apiClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [apiClient POST:kAddItemToCart parameters:[FoodBeverageServices paramsForCartItem:arrayOfiTems quantity:quantity] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (responseObject[@"status"]) {
            
        }
        successBlock(true, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(false, error);
    }];
   

}

#pragma mark - Helper Methods

+(NSDictionary *)paramsForItemList{
    
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken]
             };
    
}


+(NSDictionary *)paramsForCartItem:(NSArray *)items quantity:(NSUInteger)quantity{
   
    
//    NSMutableArray * ids_arry = [[item valueForKeyPath:@"sideItems.@distinctUnionOfObjects.foodId"] mutableCopy];
//    [ids_arry addObject:item[@"id"]];
    
    
    return @{
             @"app_bundle_id" : kAppBundleId,
             @"user_agent" : kUserAgent,
             @"auth_token" : [UserServices currentToken],
             @"menu_item_ids" : items,
             @"quantity" : [NSNumber numberWithInteger:quantity]
             };

}
@end
