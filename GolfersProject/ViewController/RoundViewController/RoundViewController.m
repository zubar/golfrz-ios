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

#import "RoundDataServices.h"
#import "GameSettings.h"
#import "RoundPlayers.h"
#import "MBProgressHUD.h"
#import "User+convenience.h"
#import "Hole.h"
#import "RoundDataServices.h"
#import "MBProgressHUD.h"
#import "SubCourse.h"
#import "Hole.h"

#define kPlayerScoreViewHeight 60.0f

@interface RoundViewController (){
    BOOL isScoreTableDescended;
}
@property (nonatomic, strong) NSMutableArray * playersInRound;
@property (nonatomic, strong) CMPopTipView * popTipView;
@property (nonatomic, strong) id editScoreBtn;
@property (nonatomic, strong) Hole * currentHole;

@property (nonatomic, strong) NSMutableArray * shots;
@property (nonatomic, assign) NSInteger pathLength;

@property (nonatomic, strong) id scoredPlayer;
@end

@implementation RoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.playersInRound) {
        self.playersInRound = [[NSMutableArray alloc]initWithCapacity:1];
    }
    
    self.pathLength = self.mapView.frame.size.width;
    if (!self.shots) self.shots = [NSMutableArray new];
    
    // Left button
    UIButton * imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 10, 14)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(roundbackBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // Right button
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"FINISH ROUND" style:UIBarButtonItemStylePlain target:self action:@selector(finishRoundTap)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self.lblHoleNo setText:[NSString stringWithFormat:@"%@", self.holeNumberPlayed]];
    [self.imgDarkerBg setHidden:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RoundDataServices getPlayersInRoundId:[[GameSettings sharedSettings] roundId]
                                   success:^(bool status, RoundPlayers *playersList) {
                                       if (status) {
                                           if ([self.playersInRound count] > 0) [self.playersInRound removeAllObjects];
                                           [self.playersInRound addObjectsFromArray:playersList.players];
                                           [self.scoreTable reloadData];
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       }
                                   } failure:^(bool status, NSError *error) {
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       NSLog(@"Error: %@", error);
                                   }];
    //TODO:
    //self.currentHole = [[PersistentServices sharedServices] current]
    //[self.scoreTable setHidden:YES];
    //isScoreTableDescended = FALSE;
}

-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
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
    // One is subtracted because one player data is displayed header view of table.
    return [self.playersInRound count] - 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString * cellIdentifier = @"PlayerScoreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PlayerScoreCell *customCell = (PlayerScoreCell *)cell;
    customCell.delegate = self;
    // One is added becasue data of first player is displayed in header view of table.
    customCell.lblPlayerName.text = [[self.playersInRound objectAtIndex:indexPath.row +1 ] contactFullName];
    [customCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return customCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kPlayerScoreViewHeight;
}


#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    User * player = nil;
    if ([self.playersInRound count] > 0) player = self.playersInRound[0];
    
    PlayerScoreView * headerView = [[PlayerScoreView alloc]init];
    
    [headerView configureViewForPlayer:nil hideDropdownBtn:NO];
    [headerView.lblUserName setText:(player != nil ? [player contactFullName] : @"")];
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

// To enter score manually for a player.

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
        self.scoredPlayer = player;
        [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
    }
    else {
        // Dismiss
        [self.popTipView dismissAnimated:YES];
        self.popTipView = nil;
    }
}

-(NSArray *)dataArrayForCells{
    
    NSMutableArray * scoresArray = [NSMutableArray new];
    for (int i = 0; i < 30; ++i) {
        [scoresArray addObject:[[NSNumber numberWithInt:i] stringValue]];
    }
    return scoresArray;
}

-(void)selectedItem:(id)item forView:(UIView *)view{
    
    NSLog(@"tapped: %@ indexPath: %@", item, view);
    if ([view isKindOfClass:[ScoreSelectionCell class]]) {
        [self.editScoreBtn setTitle:item forState:UIControlStateNormal];
    }
    self.editScoreBtn = nil;
    [self.popTipView dismissAnimated:YES];
    
    if ([item integerValue] > [self.shots count] ) {
        NSNumber * score = [NSNumber numberWithInteger:[item integerValue] - [self.shots count]];
        [self updateScore:score player:self.scoredPlayer];
    }else{
        //TODO: call the removeShots Method.
    }
}
#pragma mark - UINavigation

-(void)finishRoundTap{
    
    [RoundDataServices finishRoundWithBlock:^(bool status, id response) {
        // TODO: Navigate to ScoreCard.
    } failure:^(bool status, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Try Again" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];
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

-(void)updateScore:(NSNumber * )score player:(id)player{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    GameSettings * gameSetting = [GameSettings sharedSettings];
    
    NSNumber * holeId = nil;
    for (Hole * ahole in [[gameSetting subCourse] holes]) {
        if ([[ahole holeNumber] isEqual:self.holeNumberPlayed])
            holeId = ahole.itemId;
    }
    
    [RoundDataServices addDirectScore:score
                               holeId:holeId
                              success:^(bool status, NSDictionary *response) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  if (status)
                                      [self addShotMarker:(int)score shotType:ShotTypeStardard];
                              } failure:^(bool status, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                              }];
}

- (IBAction)btnPenaltyTapped:(UIButton *)sender {
  
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self shotHelperForShotType:ShotTypePenalty score:1 completion:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}

- (IBAction)btnShotTapped:(UIButton *)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self shotHelperForShotType:ShotTypeStardard score:1 completion:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (IBAction)btnPuttTapped:(UIButton *)sender {
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self shotHelperForShotType:ShotTypePutt score:1 completion:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)shotHelperForShotType:(ShotType)type score:(NSInteger )score completion:(void(^)(void))completion{
  
    GameSettings * gameSetting = [GameSettings sharedSettings];
    
    [RoundDataServices addShotRoundId:[gameSetting roundId]
                               holeId:self.holeNumberPlayed
                             shotType:type success:^(bool status, id response) {
                                 completion();
                                 if (status)
                                     [self addShotMarker:score shotType:type];
                             } failure:^(bool status, id response) {
                                 completion();
                                 if (!status)
                                     [[[UIAlertView alloc] initWithTitle:@"Try Again" message:@"Failed to add shot" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                             }];

}


- (IBAction)btnFlyoverTapped:(UIButton *)sender {
}
- (IBAction)btnNextHoleTapped:(UIButton *)sender {

}

- (IBAction)btnPreviousHoleTapped:(UIButton *)sender {
    
}
#pragma  mark -

#pragma mark - Shots Animation

-(void)addShotMarker:(NSInteger )quantity shotType:(ShotType )type{
    
    [self.imageMap setImage:[UIImage imageNamed:@"greenmap_selected"]];
    
    NSInteger countOFexistingShots = [self.shots count];
    NSInteger totalShotsToDisplay = countOFexistingShots + quantity;
    NSInteger internalDisplacement = 0;

    // To handle putt case 0.70 is subtraced it makes the length equal to total width of view.
    if (type == ShotTypePutt) internalDisplacement = self.pathLength / (totalShotsToDisplay - 0.70);
    else internalDisplacement = self.pathLength / (totalShotsToDisplay +1);
    
    
    NSInteger startingX = ([self.shots count] > 0 ? ((UIView *)[self.shots lastObject]).frame.origin.x : 0);
    NSInteger Ycoordinate = (self.mapView.frame.size.height / 2) - 20; // Subtracted 20 to adjust marker position along Y axis.
    
   // Add All the views to
    for (int i = 0; i < quantity; ++i) {

        CGRect initialRect;
        UIImage * shotImage = nil;
        if (type == ShotTypeStardard) shotImage = [UIImage imageNamed:@"shot_marker"];
        else if (type == ShotTypePenalty) shotImage = [UIImage imageNamed:@"shot_marker_penalty"];
        else if (type == ShotTypePutt) shotImage = [UIImage imageNamed:@"shot_marker"];
            
        
        UIImageView * aShotMarker = [[UIImageView alloc] initWithImage:shotImage];

        if ([self.shots count] > 0) {
            initialRect = ((UIImageView *)[self.shots lastObject]).frame;
        }else{
            initialRect = CGRectMake(startingX, Ycoordinate, 20, 25);
        }
        [aShotMarker setFrame:initialRect];
        [self.shots addObject:aShotMarker];
        [self.mapView addSubview:aShotMarker];
    }
    
    
    //Animate & reposition newly Added Views
    [UIView animateWithDuration:0.7 animations:^{
        for (int i = (int)countOFexistingShots ; i < [self.shots count]; ++i)
        {
            UIImageView * aShotMarker = self.shots[i];
            CGRect finalRect = CGRectMake(internalDisplacement * i, Ycoordinate, aShotMarker.frame.size.width, aShotMarker.frame.size.height);
            [aShotMarker setFrame:finalRect];
        }
    }];
    
    //Animate & reposition previously added views
    if (countOFexistingShots > 0) 
    [UIView animateWithDuration:0.7 animations:^{
        for (int i = (int)countOFexistingShots; i >= 0; --i)
        {
            UIImageView * aShotMarker = self.shots[i];
            CGRect finalRect = CGRectMake(internalDisplacement * i, Ycoordinate, aShotMarker.frame.size.width, aShotMarker.frame.size.height);
            [aShotMarker setFrame:finalRect];
        }
    }];
   
}

@end
