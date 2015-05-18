//
//  MainViewController.h
//  GolfersProject
//
//  Created by Abdullah Saeed on 4/7/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "XHTwitterPaggingViewer.h"

@protocol NavBarButtons
    -(NSDictionary *)updateNavBarRightButtons;
@end


@interface MainViewController : XHTwitterPaggingViewer
    @property (nonatomic, assign) id<NavBarButtons>delegate;
@end
