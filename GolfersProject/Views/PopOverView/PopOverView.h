//
//  PopOverView.h
//  GolfersProject
//
//  Created by Ali Ehsan on 8/16/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopOverView;

@protocol PopOverViewDelegate <NSObject>

- (void)popOverView:(PopOverView *)popOverView indexPathForSelectedRow:(NSIndexPath *)indexPath string:(NSString *)string;

@end

@interface PopOverView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *stringDataSource;
@property NSInteger maxRowVisible;
@property (nonatomic) id <PopOverViewDelegate> delegate;

- (void)showPopOverViewAnimated:(BOOL)animated inView:(UIView *)view;
- (void)dismissPopOverViewAnimated:(BOOL)animated;
- (void) setMinX:(CGFloat)minX maxY:(CGFloat)maxY width:(CGFloat)width animated:(BOOL)animated;

@end
