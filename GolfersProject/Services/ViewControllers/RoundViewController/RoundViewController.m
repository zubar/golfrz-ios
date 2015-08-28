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
#import "UserServices.h"
#import "User.h"
#import "Hole.h"
#import "Shot.h"

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
#import "PlayerSettings.h"
#import "ScoreboardServices.h"
#import "Utilities.h"
#import "RoundMoviePlayerController.h"
#import "ScoreBoardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+RoundedImage.h"
#import "GreenCoordinate.h"
#import "UIAlertView+NSCookbook.h"

#define kPlayerScoreViewHeight 60.0f

@interface RoundViewController (){
    BOOL isScoreTableDescended;
    CGPoint frontCord;
    CGPoint middleCord;
    CGPoint backCord;
    
    BOOL isUpdatingLocation;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgGPS;
@property (nonatomic, strong) NSMutableArray * playersInRound;
@property (nonatomic, strong) NSMutableDictionary * playerScores;
@property (nonatomic, strong) NSMutableDictionary * playerTotalScoreInRound;

@property (nonatomic, strong) CMPopTipView * popTipView;
@property (nonatomic, strong) id editScoreBtn;
@property (nonatomic, strong) Hole * currentHole;

@property (nonatomic, strong) NSMutableArray * shotMarkerViews;
@property (nonatomic, strong) NSMutableArray * shots;

@property (nonatomic, assign) NSInteger pathLength;

@property (nonatomic, strong) id scoredPlayer;
@property (nonatomic, strong) PlayerScoreView * headerView;
@property (nonatomic, strong) User * mySelf; // the player who has installed the app.
@end

@implementation RoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if(!self.playerScores) self.playerScores = [NSMutableDictionary new];
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];
    
    
    if (!self.playersInRound) self.playersInRound = [[NSMutableArray alloc]initWithCapacity:1];
    if (!self.playerTotalScoreInRound) self.playerTotalScoreInRound = [NSMutableDictionary new];
    
    
    self.pathLength = self.mapView.frame.size.width;
    if (!self.shotMarkerViews) self.shotMarkerViews = [NSMutableArray new];
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
    
    [self loadDataForHoleNumber:self.holeNumberPlayed :^{
        [self addShotMarker:[[self.playerScores objectForKey:[UserServices currentUserId]] integerValue] shotType:ShotTypeStardard shotId:-1];
    }];
}

-(void)loadDataForHoleNumber:(NSNumber *)holeNumber :(void(^)(void))completion{
    
    GameSettings * settings = [GameSettings sharedSettings];
    self.currentHole = [[[settings subCourse] holes] objectAtIndex:[self.holeNumberPlayed integerValue]];
    [self extractFrontMiddleBackCord];
    [[SharedManager sharedInstance] startUpdatingCurrentLocation];
    [self updateYardAndParForHole:self.currentHole];
    
    
    [self.lblHoleNo setText:[NSString stringWithFormat:@"%ld", [holeNumber integerValue]+1]];
    [self.imgDarkerBg setHidden:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RoundDataServices getPlayersInRoundId:[[GameSettings sharedSettings] roundId]
                                   success:^(bool status, RoundPlayers *playersList) {
                                       if (status) {
                                           if ([self.playersInRound count] > 0) [self.playersInRound removeAllObjects];
                                           [self.playersInRound addObjectsFromArray:playersList.players];
                                           [self setMySelfToIndexZeroFromPlayersArray];
                                           [self updateScoresOfAllPlayers:^{
                                               [self.scoreTable reloadData];
                                               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                               completion();
                                           }];
                                       }
                                   } failure:^(bool status, GolfrzError *error) {
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      // [Utilities displayErrorAlertWithMessage:[error errorMessage]];
                                       completion();
                                   }];
}

-(void)clearAllShotMarkers{
    
    // Removes all the shot markers from map.
    for (int i = 0; i < [self.shotMarkerViews count]; ++i) {
        UIView * shotMarker = self.shotMarkerViews[i];
        [shotMarker removeFromSuperview];
    }
    if([self.shotMarkerViews count] > 0)[self.shotMarkerViews removeAllObjects] ;
    if([self.shots count] > 0) [self.shots removeAllObjects];

}


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    [self updateYardAndParForHole:[[GameSettings sharedSettings] subCourse].holes[[self.holeNumberPlayed intValue]]];
    
    isUpdatingLocation = FALSE;
    [SharedManager sharedInstance].delegate = self;
}

-(void)updateYardAndParForHole:(Hole *)hole
{
    [self.lblPar setText:[[hole par] stringValue]];
    [self.lblYards setText:[[hole yards] stringValue]];
}

-(void)setMySelfToIndexZeroFromPlayersArray{
    
    NSString * currentUserId = [NSString stringWithFormat:@"%@", [UserServices currentUserId]];
    
    for (int i = 0; i < [self.playersInRound count]; ++i)
    {
        NSString * userInTraversalId = [[( User *)self.playersInRound[i] userId] stringValue];
        NSLog(@"currentUserId: %@ userInTraversal: %@", currentUserId , userInTraversalId);
        if([userInTraversalId  isEqualToString:currentUserId])
        {   // setting the self object to index Zero.
            [self.playersInRound exchangeObjectAtIndex:i withObjectAtIndex:0];
        }
    }
}

-(void)updateScoresOfAllPlayers:(void(^)(void))completion{
    
    __block NSInteger numberOfCalls =0;
    for (User * player in self.playersInRound) {
        ++numberOfCalls;
        [self currentHoleScoreForPlayerId:player.userId completion:^(NSNumber * score)
         {
             --numberOfCalls;
             [self.playerScores setObject:score forKey:player.userId];
             if(numberOfCalls == 0)
                 //[self.scoreTable reloadData];
                 [self updateRoundTotalForAllPlayers:^{
                     completion();
                 }];
         }];
    }
}



-(void)updateRoundTotalForAllPlayers:(void(^)(void))completion{
    
    GameSettings * setttings = [GameSettings sharedSettings];
    
    [ScoreboardServices getTotalScoreForAllPlayersForRoundId:[setttings roundId] success:^(bool status, NSDictionary *playerTotalScore) {
        if([self.playerTotalScoreInRound count] > 0)[self.playerTotalScoreInRound removeAllObjects];
            [self.playerTotalScoreInRound setDictionary:playerTotalScore];
        completion();
    } failure:^(bool status, GolfrzError *error) {
        completion();
        //[Utilities displayErrorAlertWithMessage:[error errorMessage]]; //This is removed temporarily as API is not mature enough and it is displaying error on first time
    }];
}

-(void)currentHoleScoreForPlayerId:(NSNumber *)playerId completion:(void(^)(NSNumber *))score{
    
    GameSettings * settings = [GameSettings sharedSettings];
    [ScoreboardServices getScoreForUserId:playerId
                                   holeId:self.currentHole.itemId
                                  roundId:[settings roundId]
                                  success:^(bool status, id response) {
                                            score(response);
                                  }failure:^(bool status, GolfrzError *error) {
                                      score([NSNumber numberWithInt:0]);
                                      [Utilities displayErrorAlertWithMessage:[error errorMessage]];
                                  }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self dropDownTapped];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:YES];
    [SharedManager sharedInstance].delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // One is subtracted because one player data is displayed header view of table.
    return [self.playersInRound count] - 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"PlayerScoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    User * player = [self.playersInRound objectAtIndex:indexPath.row +1 ];
    PlayerScoreCell *customCell = (PlayerScoreCell *)cell;
    customCell.delegate = self;
    [customCell.imgPlayerPic sd_setImageWithURL:[NSURL URLWithString:[player imgPath]] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [customCell.imgPlayerPic setRoundedImage:image];
        }
    }];
    
    // One is added becasue data of first player is displayed in header view of table.
    customCell.lblPlayerName.text = [player contactFullName];
    customCell.player = player;
    [customCell.lblScore setText:[[self.playerTotalScoreInRound objectForKey:[player.userId stringValue]] stringValue]];
    [customCell.btnScore setTitle:[[self.playerScores objectForKey:player.userId] stringValue] forState:UIControlStateNormal];
    [customCell.lblInOut setText:([self.currentHole.holeNumber integerValue] <= 9 ? @"OUT" : @"IN")];
    [customCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return customCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPlayerScoreViewHeight;
}


#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    User * player = nil;
    // Assumes that in playersInRound Array signedIn player object is always at index Zero.
    if ([self.playersInRound count] > 0) player = self.playersInRound[0];
    if (!self.headerView) self.headerView = [[PlayerScoreView alloc]init];
    
    
    [self.headerView configureViewForPlayer:player hideDropdownBtn:NO];
    [self.headerView.lblUserName setText:(player != nil ? [player contactFullName] : @"")];
    [self.headerView.imgUserPic sd_setImageWithURL:[NSURL URLWithString:[player imgPath]] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.headerView.imgUserPic setRoundedImage:image];
        }
    }];
    [self.headerView.lblScoreForHole setText:[[self.playerTotalScoreInRound objectForKey:[player.userId stringValue]] stringValue]];
    [self.headerView.btnEditScore setTitle:[[self.playerScores objectForKey:player.userId] stringValue] forState:UIControlStateNormal];
    [self.headerView.lblInOut setText:([self.currentHole.holeNumber integerValue] <= 9 ? @"OUT" : @"IN")];
    self.headerView.delegate = self;
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kPlayerScoreViewHeight;
}
#pragma mark - PlayerScoreViewDelegate
-(void)dropDownTapped
{
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

-(void)showDistanceView:(BOOL)yesNo
{
    [self.distanceView setHidden:!(yesNo)];
    
    if(!yesNo) [self.headerView.btnShowTable setImage:[UIImage imageNamed:@"dropdown_uparrow"] forState:UIControlStateNormal];
    else [self.headerView.btnShowTable setImage:[UIImage imageNamed:@"dropdown_downarrow"] forState:UIControlStateNormal];
}
// To enter score manually for a player.
-(void)editScoreTappedForPlayer:(id)sender Player:(id)player view:(UIView *)view
{
    ScoreSelectionView * mScoreView = [[ScoreSelectionView alloc]init];
    mScoreView.dataSource = self;
    mScoreView.delegate = self;
    [mScoreView setBackgroundColor:[UIColor whiteColor]];
    
    
    // Toggle popTipView when a standard UIButton is pressed
    if (nil == self.popTipView) {
        self.popTipView = [[CMPopTipView alloc] initWithCustomView:mScoreView];
        self.popTipView.delegate = self;
        self.popTipView.backgroundColor = [UIColor whiteColor];
        [self.popTipView setCornerRadius:0.0f];
        // saving the ref to selected view.
        self.editScoreBtn = sender;
        self.scoredPlayer = player;
        [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
    }else {
        // Dismiss
        [self.popTipView dismissAnimated:YES];
        self.popTipView = nil;
    }
}

-(NSArray *)dataArrayForCells
{
    NSMutableArray * scoresArray = [NSMutableArray new];
    for (int i = 1; i < 30; ++i) {
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
    
    if ([item integerValue] > [self.shotMarkerViews count] ) {
        NSNumber * score = [NSNumber numberWithInteger:[item integerValue]];
        [self updateScore:score player:self.scoredPlayer];
    }else{
        NSNumber * score = [NSNumber numberWithInteger:[item integerValue]];
        [self updateScore:score player:self.scoredPlayer];
    }
}
#pragma mark - UINavigation

-(void)showAlertNoRoundInProgress{
    [[[UIAlertView alloc] initWithTitle:@"No Round InProgress" message:@"You have finished all rounds." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

-(void)finishRoundTap
{
    if([[GameSettings sharedSettings] roundId] == (NSNumber *)[NSNull null]|| [[GameSettings sharedSettings] subCourseId]== (NSNumber *)[NSNull null]){
        [self showAlertNoRoundInProgress];
        return;
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RoundDataServices finishRoundWithBlock:^(bool status, id response) {
        // Navigate to ScoreCard.
        if(status){
            
            // Getting score-card.
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [ScoreboardServices getScoreCardForRoundId:[[GameSettings sharedSettings] roundId] subCourse:[[GameSettings sharedSettings] subCourseId] success:^(bool status, id responseObject) {
                if(status){
                    //Load scorecard here.
                    ScoreBoardViewController *scoreBoardVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SCORE_BOARD_VC_ID"];
                    scoreBoardVc.roundId = [[GameSettings sharedSettings] roundId];
                    scoreBoardVc.subCourseId = [[GameSettings sharedSettings] subCourseId];
                    [self.navigationController pushViewController:scoreBoardVc animated:YES];
                   
                }
            } failure:^(bool status, NSError *error) {
                [[[UIAlertView alloc] initWithTitle:@"Try Again." message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }];
        }
    } failure:^(bool status, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Try Again." message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];
}

-(void)roundbackBtnTapped
{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController popViewControllerAnimated:YES];
}

#pragma mark CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    // User can tap CMPopTipView to dismiss it
    self.popTipView = nil;
}


#pragma mark - Animation
-(void)descendTableViewWithAnimation:(BOOL)yesNo completion:(void(^)(void))completionBlock{
    
    [self.scoreTable setScrollEnabled:YES];
    
    CGRect initalFrame = [self.scoreTable frame];
    CGRect finalFrame = CGRectMake(0, initalFrame.origin.y, initalFrame.size.width, kPlayerScoreViewHeight * 3);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.scoreTable setFrame:finalFrame];
        [self.imgDarkerBg setHidden:NO];
    } completion:^(BOOL finished) {
        if (completionBlock)
            completionBlock();
    }];
}

-(void)ascendTableViewWithAnimation:(BOOL)yesNo completion:(void(^)(void))completionBlock
{
    [self.scoreTable setScrollEnabled:NO];
    CGRect initalFrame = [self.scoreTable frame];
    CGRect finalFrame = CGRectMake(0, initalFrame.origin.y, initalFrame.size.width, kPlayerScoreViewHeight);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.scoreTable setFrame:finalFrame];
        [self.imgDarkerBg setHidden:YES];
    } completion:^(BOOL finished) {
        if (completionBlock)
            completionBlock();
    }];
    
}

#pragma mark - UIActions

-(void)updateScore:(NSNumber * )score player:(id)player
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSNumber * playerId = [player userId];
    [RoundDataServices addDirectScore:score
                               holeId:[self.currentHole itemId]
                             playerId:playerId
                              success:^(bool status, NSDictionary *response) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  if (status){
                                      // Only Add shot Marker for signed-in player
                                      if([playerId isEqual:[UserServices currentUserId]]){
                                          [self updateShots:[score integerValue]];
                                        }
                                      else
                                          [[[UIAlertView alloc] initWithTitle:@"Score Updated" message:@"Score updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                                      // Update players score.
                                      [self updateScoresOfAllPlayers:^{
                                          [self.scoreTable reloadData];
                                      }];
                                  }
                              } failure:^(bool status, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                              }];
}

-(void)updateShots:(NSInteger )shotsCount{
    
    NSInteger existingShots = [[self.playerScores objectForKey:[UserServices currentUserId]] integerValue];
    if(shotsCount > existingShots)
        [self addShotMarker:shotsCount-existingShots shotType:ShotTypeStardard shotId:-1];
    else
        if(shotsCount == existingShots) return;
    else
        if(shotsCount < existingShots){
            [self clearAllShotMarkers];
            [self addShotMarker:shotsCount shotType:ShotTypeStardard shotId:-1];
        }
}

- (IBAction)btnPenaltyTapped:(UIButton *)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self shotHelperForShotType:ShotTypePenalty score:1 completion:^{
        [self updateScoresOfAllPlayers:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.scoreTable reloadData];
        }];
    }];
}

- (IBAction)btnShotTapped:(UIButton *)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self shotHelperForShotType:ShotTypeStardard score:1 completion:^{
        [self updateScoresOfAllPlayers:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.scoreTable reloadData];
        }];
    }];
}

- (IBAction)btnPuttTapped:(UIButton *)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self shotHelperForShotType:ShotTypePutt score:1 completion:^{
        [self updateScoresOfAllPlayers:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.scoreTable reloadData];
        }];
    }];
}

-(void)shotHelperForShotType:(ShotType)type score:(NSInteger )score completion:(void(^)(void))completion{
    
    GameSettings * gameSetting = [GameSettings sharedSettings];
    
    [RoundDataServices addShotRoundId:[gameSetting roundId]
                               holeId:[self.currentHole itemId]
                             shotType:type success:^(bool status, id response) {
                                 
                                 if (status){
                                     Shot * aShot = (Shot *)response;
                                     [self.shots addObject:response];
                                     [self addShotMarker:score shotType:type shotId:[[aShot itemId] integerValue]];
                                 }
                                 completion();
                             } failure:^(bool status, id response) {
                                 if (!status)
                                     [[[UIAlertView alloc] initWithTitle:@"Try Again" message:@"Failed to add shot" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                                 completion();
                             }];
    
}

-(void)deleteShot:(UITapGestureRecognizer *)sender{
    // check if shots array contains shots.
    if([self.shots count] <= 0){
        [[[UIAlertView alloc] initWithTitle:@"Update Score Manually!" message:@"This shot can't be deleted by tapping on shot, please update the score for this hole manually." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
    UIAlertView * confirmationAlert =  [[UIAlertView alloc] initWithTitle:@"Confirmation!" message:@"Are you sure you want to delete this shot ?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [confirmationAlert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) { // means user tapped Delete button
           
            __block BOOL shotIdFount = FALSE;
            UIImageView *tappedShot = (UIImageView *)sender.view;
            NSInteger tag = [tappedShot tag];
            for (int i = 0; i < [self.shots count] ; ++i) {
                Shot * aShot = self.shots[i];
                if(tag == [[aShot itemId] integerValue]){
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [RoundDataServices deleteShot:aShot success:^(bool status, id response) {
                        shotIdFount = TRUE;
                        [tappedShot removeFromSuperview];
                        [self.shotMarkerViews removeObject:tappedShot];
                        [self.shots removeObjectAtIndex:i];
                        
                        [self updateScoresOfAllPlayers:^{
                            [self.scoreTable reloadData];
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        }];
                        
                    } failure:^(bool status, NSError *error) {
                        [[[UIAlertView alloc] initWithTitle:@"Update Score Manually!" message:@"This shot can't be deleted by tapping on shot, please update the score for this hole manually." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                    }];
                }
            }
        }
    }];
}

- (IBAction)btnFlyoverTapped:(UIButton *)sender
{
    if ([self.currentHole flyOverVideoPath] == nil ||
        [self.currentHole flyOverVideoPath] == NULL ||
        [[self.currentHole flyOverVideoPath] containsString:@"No Fly Over Video Specified"])
    {
        [[[UIAlertView alloc] initWithTitle:@"Flyover Video Not Available!" message:@"Flyover video is not available for this hole." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    RoundMoviePlayerController *movieController = [RoundMoviePlayerController new];
    movieController.moviePath =[self.currentHole flyOverVideoPath];
    [self.navigationController pushViewController:movieController animated:YES];
}

- (IBAction)btnNextHoleTapped:(UIButton *)sender {
    
    GameSettings * settings = [GameSettings sharedSettings];
    NSInteger  countOfHoles = [[settings totalNumberOfHoles] integerValue];
    NSInteger holePlayed = [self.holeNumberPlayed integerValue];
    
    if ((holePlayed + 1) < countOfHoles ) {
        ++holePlayed;
        self.holeNumberPlayed = [NSNumber numberWithInteger:holePlayed];
        [self clearAllShotMarkers];
        [self loadDataForHoleNumber:self.holeNumberPlayed :^{
            [self addShotMarker:[[self.playerScores objectForKey:[UserServices currentUserId]] integerValue] shotType:ShotTypeStardard shotId:-1];
        }];
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Last Hole Reached!" message:@"Its the last hole in current round. There is no next hole." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)btnPreviousHoleTapped:(UIButton *)sender {
    
    NSInteger holePlayed = [self.holeNumberPlayed integerValue];
    
    if ((holePlayed - 1) >= 0){
        --holePlayed;
        self.holeNumberPlayed = [NSNumber numberWithInteger:holePlayed];
        [self clearAllShotMarkers];
        [self loadDataForHoleNumber:self.holeNumberPlayed :^{
            [self addShotMarker:[[self.playerScores objectForKey:[UserServices currentUserId]] integerValue] shotType:ShotTypeStardard shotId:-1];
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"First Hole Reached!" message:@"Its the first hole in current round. There is no previous hole." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}
#pragma  mark -

#pragma mark - Shots Animation

-(void)addShotMarker:(NSInteger )quantity shotType:(ShotType )type shotId:(NSInteger )shotId{
    
    if (quantity <= 0) return;
    
    [self.imageMap setImage:[UIImage imageNamed:@"greenmap_selected"]];
    
    NSInteger countOFexistingShots = [self.shotMarkerViews count];
    NSInteger totalShotsToDisplay = countOFexistingShots + quantity;
    NSInteger internalDisplacement = 0;
    
    // To handle putt case 0.70 is subtraced it makes the length equal to total width of view.
    if (type == ShotTypePutt) internalDisplacement = self.pathLength / (totalShotsToDisplay - 0.75);
    else internalDisplacement = self.pathLength / (totalShotsToDisplay +1);
    
    
    NSInteger startingX = ([self.shotMarkerViews count] > 0 ? ((UIView *)[self.shotMarkerViews lastObject]).frame.origin.x : 0);
    NSInteger Ycoordinate = (self.mapView.frame.size.height / 2) - 20; // Subtracted 20 to adjust marker position along Y axis.
    
    // Add All the views to
    for (int i = 0; i < quantity; ++i) {
        
        CGRect initialRect;
        UIImage * shotImage = nil;
        if (type == ShotTypeStardard) shotImage = [UIImage imageNamed:@"shot_marker"];
        else if (type == ShotTypePenalty) shotImage = [UIImage imageNamed:@"shot_marker_penalty"];
        else if (type == ShotTypePutt) shotImage = [UIImage imageNamed:@"shot_marker"];
        
        
        UIImageView * aShotMarker = [[UIImageView alloc] initWithImage:shotImage];
        if(shotId > 0){
            [aShotMarker setTag:shotId];
        }
        [aShotMarker setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteShot:)];
        [aShotMarker addGestureRecognizer:tap];

        
        if ([self.shotMarkerViews count] > 0) {
            initialRect = ((UIImageView *)[self.shotMarkerViews lastObject]).frame;
        }else{
            initialRect = CGRectMake(startingX, Ycoordinate, 20, 25);
        }
        [aShotMarker setFrame:initialRect];
        [self.shotMarkerViews addObject:aShotMarker];
        [self.mapView addSubview:aShotMarker];
    }
    
    //Animate & reposition newly Added Views
    [UIView animateWithDuration:0.7 animations:^{
        for (int i = (int)countOFexistingShots ; i < [self.shotMarkerViews count]; ++i)
        {
            UIImageView * aShotMarker = self.shotMarkerViews[i];
            CGRect finalRect = CGRectMake(internalDisplacement * i, Ycoordinate, aShotMarker.frame.size.width, aShotMarker.frame.size.height);
            [aShotMarker setFrame:finalRect];
        }
    }];
    
    //Animate & reposition previously added views
    if (countOFexistingShots > 0)
        [UIView animateWithDuration:0.7 animations:^{
            for (int i = (int)countOFexistingShots; i >= 0; --i)
            {
                UIImageView * aShotMarker = self.shotMarkerViews[i];
                CGRect finalRect = CGRectMake(internalDisplacement * i, Ycoordinate, aShotMarker.frame.size.width, aShotMarker.frame.size.height);
                [aShotMarker setFrame:finalRect];
            }
        }];
}

#pragma mark - Location related stuff

-(void)extractFrontMiddleBackCord{
    
    for (GreenCoordinate * cordinate in [self.currentHole greenCoordinates]) {
        if([[cordinate type] isEqualToString:GREEN_FRONT])
            frontCord = CGPointMake([cordinate.longitude doubleValue], [cordinate.latitude doubleValue]);
        
        if([[cordinate type] isEqualToString:GREEN_MIDDLE])
            middleCord = CGPointMake([cordinate.longitude doubleValue], [cordinate.latitude doubleValue]);
        
        if([[cordinate type] isEqualToString:GREEN_BACK])
            backCord = CGPointMake([cordinate.longitude doubleValue], [cordinate.latitude doubleValue]);
            }
}

-(void)isUpdatingCurrentLocation:(BOOL)yesNo locationCordinates:(CGPoint)cord
{
    isUpdatingLocation = yesNo;
    [self updateDistanceForLoc:cord onLabel:self.lblForward fromCord:frontCord];
    [self updateDistanceForLoc:cord onLabel:self.lblMiddle fromCord:middleCord];
    [self updateDistanceForLoc:cord onLabel:self.lblBack fromCord:backCord];
   
    /*
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse  animations:^{
        self.imgGPS.alpha = 1;
    } completion:^(BOOL finished) {
        if(!isUpdatingLocation) [self.imgGPS.layer removeAllAnimations];
            }];
     */

}

-(void)updateDistanceForLoc:(CGPoint)cord onLabel:(UILabel *)frontmidlbl fromCord:(CGPoint)holeGreenCord
{
    int dist = [self yardsfromPlace:cord andToPlace:holeGreenCord];
    NSString * lbl =[NSString stringWithFormat:@"%@", (dist <= 999 ? [NSString stringWithFormat:@"%d", dist] : @"--")];
    [frontmidlbl setText:lbl];
}

-(int)yardsfromPlace:(CGPoint )from andToPlace:(CGPoint)to
{
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.y longitude:from.x];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.y longitude:to.x];
    CLLocationDistance dist = [userloc distanceFromLocation:dest];
    NSLog(@"Dist: %f",dist);
    NSString *distance = [NSString stringWithFormat:@"%f",dist];
    int distYards = [distance intValue] * 1.09361;
   
   NSLog(@"DistInYards: %d",distYards);

    return distYards;
}

-(NSString *)getFirstThreeDigits:(int)distance
{
    NSString * n = [NSString stringWithFormat:@"%d", distance];
    NSString * s = [n substringToIndex:3];
    return s;
}


@end
