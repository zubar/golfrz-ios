//
//  PopOverView.m
//  GolfersProject
//
//  Created by Ali Ehsan on 8/16/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PopOverView.h"
#import "PopOverCell.h"

@interface PopOverView ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PopOverCell *dummyCell;
@property (nonatomic) BOOL isShown;
@property (nonatomic) CGFloat minX;
@property (nonatomic) CGFloat maxY;
@property (nonatomic) CGFloat width;

- (NSInteger)getDynamicHeightOfTableView;

@end

@implementation PopOverView

#pragma mark - init methods

- (id) init {
    self = [super init];

    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PopOverView class]) owner:self options:nil] firstObject];
        
        // Init values of variables.
        self.maxRowVisible = 3;
        self.dummyCell = [[PopOverCell alloc] init];
        self.isShown = NO;
        self.stringDataSource = [NSArray new];
        
        // Set table view border color.
        self.tableView.layer.borderColor = [[UIColor blackColor] CGColor];
        
        // Register Nibs.
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PopOverCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PopOverCell class])];
        
    }
    return self;
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.stringDataSource count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopOverCell *cell = (PopOverCell *) [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PopOverCell class]) forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row == self.stringDataSource.count - 1) {
        cell.seperatorView.hidden = YES;
    }
    else {
        cell.seperatorView.hidden = NO;
    }
    
    if ([self.stringDataSource[indexPath.row] isKindOfClass:[NSString class]]) {
        cell.nameLabel.text = self.stringDataSource[indexPath.row];
    }
    else {
        NSLog(@"Warning: Data will not be visible beacuse it is not of type NSString class.");
    }
    
    return cell;

}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetHeight(self.dummyCell.frame);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!(self.delegate && [self.delegate respondsToSelector:@selector(popOverView:indexPathForSelectedRow:string:)])) {
        return;
    }
    [self.delegate popOverView:self indexPathForSelectedRow:indexPath string:self.stringDataSource[indexPath.row]];
}

#pragma mark - height and frame methods

- (NSInteger)getDynamicHeightOfTableView {
    NSInteger heightOfCell = CGRectGetHeight(self.dummyCell.frame);
    NSInteger heightOfTableView = 0;
    
    if (self.stringDataSource.count > self.maxRowVisible) {
        heightOfTableView = heightOfCell * self.maxRowVisible;
    }
    else {
        heightOfTableView = heightOfCell * self.stringDataSource.count;
    }
    return heightOfTableView;
}

- (void) setMinX:(CGFloat)minX maxY:(CGFloat)maxY width:(CGFloat)width animated:(BOOL)animated {
    
    self.minX = minX;
    self.maxY = maxY;
    self.width = width;
    
    self.frame = CGRectMake(self.minX, self.maxY, self.width, 0.0);
    self.isShown = NO;
}

#pragma mark - stringDataSource methods

- (void)setStringDataSource:(NSArray *)stringDataSource {
    _stringDataSource = [stringDataSource copy];
    
    [self.tableView reloadData];
}

#pragma mark - visiblilty methods

- (void)showPopOverViewAnimated:(BOOL)animated inView:(UIView *)view{
    if (!self.isShown) {
        self.isShown = !self.isShown;
        NSTimeInterval duration = 0;
        if (animated) {
            duration = 0.25;
        }
        NSInteger heightOfTableView = [self getDynamicHeightOfTableView];
        
        self.frame = CGRectMake(self.minX, self.maxY, self.width, 0.0);
        [view addSubview:self];
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(self.minX, self.maxY - heightOfTableView, self.width, [self getDynamicHeightOfTableView]);
        }];
    }
}

- (void)dismissPopOverViewAnimated:(BOOL)animated {
    if (self.isShown) {
        self.isShown = !self.isShown;
        NSTimeInterval duration = 0;
        if (animated) {
            duration = 0.25;
        }
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(self.minX, self.maxY, self.width, 0.0);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

@end
