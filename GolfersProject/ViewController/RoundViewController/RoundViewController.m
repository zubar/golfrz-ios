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
#import "ScoreSelectionView.h"
#import "ScoreSelectionCell.h"


#define kPlayerScoreViewHeight 60.0f

@interface RoundViewController (){
    BOOL isScoreTableDescended;
}
@property (nonatomic, strong) NSMutableArray * playersInRound;
@property (nonatomic, strong) CMPopTipView * popTipView;
@property (nonatomic, strong) id editScoreBtn;
@end

@implementation RoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.playersInRound) {
        self.playersInRound = [[NSMutableArray alloc]initWithCapacity:1];
        [self.playersInRound addObjectsFromArray:[NSArray arrayWithObjects:@"obj",@"obj",@"obj",@"obj",@"obj",@"obj",@"obj", nil]];
    }
    
    // Left button
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(roundbackBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // Right button
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"FINISH ROUND" style:UIBarButtonItemStylePlain target:self action:@selector(finishRoundTap)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //TODO: set attributed text in right Btn Label
    /*
    NSDictionary *navTitleAttributes =@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                        NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.0],
                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                        };
    */
    
    [self.imgDarkerBg setHidden:YES];
    //[self.scoreTable setHidden:YES];
    //isScoreTableDescended = FALSE;
}

-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
//    CGRect initalFrame = [self.scoreTable frame];
//    CGRect finalFrame = CGRectMake(0, initalFrame.origin.y, initalFrame.size.width, 0);
//    [self.scoreTable setFrame:finalFrame];
}

-(void)viewDidAppear:(BOOL)animated{
    [self dropDownTapped];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)dropShotMarkerType:(NSString *)shotTypeENUM{
//    
//    CGRect initialFrame = nil;
//   
//    
//    CGRect finalFrame = nil;
//    
//    UIImageView * markerImage = nil;
//    [markerImage setFrame:initialFrame];
//    
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        [markerImage setFrame:finalFrame];
//    } completion:^(BOOL finished) {
//        
//    }];
//}

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
    customCell.delegate = self;
    customCell.lblPlayerName.text = [self.playersInRound objectAtIndex:indexPath.row];
    [customCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return customCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kPlayerScoreViewHeight;
}


#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    PlayerScoreView * headerView = [[PlayerScoreView alloc]init];
   // [headerView setBackgroundColor:[UIColor clearColor]];
    
    [headerView configureViewForPlayer:nil hideDropdownBtn:NO];
    [headerView.lblUserName setText:@"Test User"];
    headerView.delegate = self;
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return kPlayerScoreViewHeight;
}



#pragma mark - PlayerScoreViewDelegate

-(void)dropDownTapped{

    if (isScoreTableDescended) {
        isScoreTableDescended = FALSE;
        [self showDistanceView:isScoreTableDescended];
        [self descendTableViewWithAnimation:YES completion:^{
        }];
    }else{
        [self ascendTableViewWithAnimation:YES completion:^{
            isScoreTableDescended = TRUE;
            [self showDistanceView:isScoreTableDescended];
        }];
    }
}

-(void)showDistanceView:(BOOL)yesNo{
    //bool visibleStatus = !yesNo;
    [self.distanceView setHidden:!(yesNo)];
}

-(void)editScoreTappedForPlayer:(id)sender Player:(id)player view:(UIView *)view{

    ScoreSelectionView * mScoreView = [[ScoreSelectionView alloc]init];
    mScoreView.dataSource = self;
    mScoreView.delegate = self;
    [mScoreView setBackgroundColor:[UIColor whiteColor]];
    
    
    // Toggle popTipView when a standard UIButton is pressed
    if (nil == self.popTipView) {
        self.popTipView = [[CMPopTipView alloc] initWithCustomView:mScoreView];
        self.popTipView.delegate = self;
        self.popTipView.backgroundColor = [UIColor whiteColor];
        // saving the ref to selected view.
        self.editScoreBtn = sender;
        [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
    }
    else {
        // Dismiss
        [self.popTipView dismissAnimated:YES];
        self.popTipView = nil;
    }
}

-(NSArray *)dataArrayForCells{
    return [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
}

-(void)selectedItem:(id)item forView:(UIView *)view{
    
    NSLog(@"tapped: %@ indexPath: %@", item, view);
    if ([view isKindOfClass:[ScoreSelectionCell class]]) {
        [self.editScoreBtn setTitle:item forState:UIControlStateNormal];
    }
    self.editScoreBtn = nil;
    [self.popTipView dismissAnimated:YES];
}
#pragma mark - UINavigation

-(void)finishRoundTap{


}

-(void)roundbackBtnTapped{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController popViewControllerAnimated:YES];
}


#pragma mark CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // User can tap CMPopTipView to dismiss it
    self.popTipView = nil;
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
    
    [self.scoreTable setScrollEnabled:YES];
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGRect initalFrame = [self.scoreTable frame];
    CGRect finalFrame = CGRectMake(0, initalFrame.origin.y, initalFrame.size.width, appFrame.size.height * 0.5);
    
    
    //TODO: change button image of header on completion.
    [UIView animateWithDuration:0.5 animations:^{
        [self.scoreTable setFrame:finalFrame];
        [self.imgDarkerBg setHidden:NO];
    } completion:^(BOOL finished) {
        if (completionBlock)
            completionBlock();
    }];
}

-(void)ascendTableViewWithAnimation:(BOOL)yesNo completion:(void(^)(void))completionBlock{
    
    [self.scoreTable setScrollEnabled:NO];
    CGRect initalFrame = [self.scoreTable frame];
    CGRect finalFrame = CGRectMake(0, initalFrame.origin.y, initalFrame.size.width, kPlayerScoreViewHeight);
    
    
    //TODO: change button image of header on completion.
    [UIView animateWithDuration:0.5 animations:^{
        [self.scoreTable setFrame:finalFrame];
        [self.imgDarkerBg setHidden:YES];
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
