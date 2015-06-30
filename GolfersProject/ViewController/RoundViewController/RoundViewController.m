//
//  RoundViewController.m
//  GolfersProject
//
//  Created by Zubair on 6/26/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RoundViewController.h"
#import "PlayerScoreCell.h"
#import "PlayerProfileViewController.h"
#import "PlayerScoreView.h"
#import "PlayerScoreCell.h"
#import "AppDelegate.h"

#define kPlayerScoreViewHeight 60.0f

@interface RoundViewController (){
    BOOL isScoreTableDescended;
}
@property (nonatomic, strong) NSMutableArray * playersInRound;
@end

@implementation RoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.playersInRound) {
        self.playersInRound = [[NSMutableArray alloc]initWithCapacity:1];
        [self.playersInRound addObjectsFromArray:[NSArray arrayWithObjects:@"obj",@"obj",@"obj",@"obj",@"obj",@"obj",@"obj", nil]];
    }
    
    isScoreTableDescended = FALSE;
}

-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate * delegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.playersInRound count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString * cellIdentifier = @"PlayerScoreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PlayerScoreCell *customCell = (PlayerScoreCell *)cell;
    customCell.lblPlayerName.text = [self.playersInRound objectAtIndex:indexPath.row];
    return customCell;
    
//    if (customCell == nil) {
//        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    [tableView setBackgroundColor:[UIColor clearColor]];
//    
//    PlayerScoreView * customView = [[PlayerScoreView alloc]init];
//    [customView setBackgroundColor:[UIColor clearColor]];
//
//    [customView configureViewForPlayer:nil hideDropdownBtn:NO];
//    customView.delegate = self;
//    
//    [customCell.contentView addSubview:customView];
//    
////    PlayerScoreCell *customViewCell = (PlayerScoreCell *)customCell;
////    customViewCell.contentView addSubview:<#(UIView *)#>
//    
//    return customCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kPlayerScoreViewHeight;
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    PlayerScoreView * headerView = [[PlayerScoreView alloc]init];
    [headerView configureViewForPlayer:nil hideDropdownBtn:NO];
    [headerView.lblUserName setText:@"Test User"];

    //[headerView setBackgroundColor:[UIColor clearColor]];
    
    headerView.delegate = self;
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return kPlayerScoreViewHeight;
}



#pragma mark - PlayerScoreViewDelegate

-(void)dropDownTapped{

    if (isScoreTableDescended) {
        [self descendTableViewWithAnimation:YES completion:^{
            isScoreTableDescended = FALSE;
        }];
    }else{
        [self ascendTableViewWithAnimation:YES completion:^{
            isScoreTableDescended = TRUE;
        }];
    }
    
    
}

-(void)editScoreTappedForPlayer:(id)player{
        //TODO: display popover here.
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Animation
-(void)descendTableViewWithAnimation:(BOOL)yesNo completion:(void(^)(void))completionBlock{
    
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGRect initalFrame = [self.scoreTable frame];
    CGRect finalFrame = CGRectMake(0, initalFrame.origin.y, initalFrame.size.width, appFrame.size.height * 0.5);
    
    
    //TODO: change button image of header on completion.
    [UIView animateWithDuration:0.5 animations:^{
        [self.scoreTable setFrame:finalFrame];
    } completion:^(BOOL finished) {
        if (completionBlock)
            completionBlock();
    }];
}

-(void)ascendTableViewWithAnimation:(BOOL)yesNo completion:(void(^)(void))completionBlock{
    
    CGRect initalFrame = [self.scoreTable frame];
    CGRect finalFrame = CGRectMake(0, initalFrame.origin.y, initalFrame.size.width, kPlayerScoreViewHeight);
    
    
    //TODO: change button image of header on completion.
    [UIView animateWithDuration:0.5 animations:^{
        [self.scoreTable setFrame:finalFrame];
    } completion:^(BOOL finished) {
        if (completionBlock)
            completionBlock();
    }];

}

#pragma mark - UIActions

- (IBAction)btnPenaltyTapped:(UIButton *)sender {
}

- (IBAction)btnShotTapped:(UIButton *)sender {
}

- (IBAction)btnPuttTapped:(UIButton *)sender {
}

- (IBAction)btnFlyoverTapped:(UIButton *)sender {
}
- (IBAction)btnNextHoleTapped:(UIButton *)sender {
}

- (IBAction)btnPreviousHoleTapped:(UIButton *)sender {
}
@end
