//
//  AddPlayersViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/1/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "AddPlayersViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+RoundedImage.h"

#import "SubCourse.h"
#import "GameType.h"
#import "ScoreType.h"
#import "Hole.h"
#import "Teebox.h"
#import "User.h"
#import "SharedManager.h"
#import "InvitationServices.h"
#import "Round.h"
#import "RoundMetaData.h"

#import "RoundDataServices.h"
#import "MBProgressHUD.h"
#import "ScoreSelectionView.h"
#import "RoundInviteViewController.h"
#import "RoundPlayerCell.h"
#import "RoundDataServices.h"
#import "GameSettings.h"
#import "HolesMapViewController.h"
#import "RoundDataServices.h"
#import "RoundPlayers.h"
#import "Utilities.h"

@interface AddPlayersViewController (){
    DropDownContainsItems currentItemsIndropdown;
    NSString * userSelectedTeebox;
    BOOL isRoundInProgress;
}
@property (nonatomic, strong) SubCourse * selectedSubCourse;
@property (nonatomic, strong) GameType * selectedGameType;
@property (nonatomic, strong) ScoreType * selectedScoreType;
@property (nonatomic, strong) Teebox * selectedTeeBox;

@property (nonatomic, strong) PopOverView *popOverView;

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * playersInRound;

- (void)presentPopOverViewPointedAtButton:(UIView *)sender;

@end


@implementation AddPlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];
    
    // Init pop over view.
    self.popOverView = [[PopOverView alloc] init];
    self.popOverView.delegate = self;
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.playersInRound = [[NSMutableArray alloc] init];
    currentItemsIndropdown = DropDownContainsItemsNone;
    
    
    // Right bar button
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel Round" style:UIBarButtonItemStylePlain target:self action:@selector(cancelRound)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    /*
     This notification is posted by PushManager class, it informs that someone has accepted the invitation for round.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:kInviteeAcceptedInvitation object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:kAppLaunchUserTapInvitationLink object:nil];
    
}

-(void)showPlayerTable:(BOOL)tablShow showStartBtn:(BOOL)btnShow isStartTitleContinue:(BOOL)btntitle showAddplyerbtn:(BOOL)btnAddplayr{
    
    if(btntitle)
        [self.btnStartRound setTitle:@"CONTINUE ROUND" forState:UIControlStateNormal];
    else
        [self.btnStartRound setTitle:@"START NEW ROUND" forState:UIControlStateNormal];

    [self.playersTableContainerView setHidden:!tablShow];
    [self.addPlayerContainerView setHidden:!btnAddplayr];
    
    [self.btnStartRound setHidden:!btnShow];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];

    [self showPlayerTable:NO showStartBtn:YES isStartTitleContinue:NO showAddplyerbtn:YES];
    
    GameSettings * settings = [GameSettings sharedSettings];
    if([settings invitationToken] != (NSString *)[NSNull null] && [settings invitationToken] !=nil){
        [self loadDataUserAcceptedInvitation];
    }else
        [self loadData];
}

-(void)loadData
{
    
    GameSettings * settings = [GameSettings sharedSettings];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // If user comes to the View and a round is already in-Progress.
    [self getPreviousRoundStatus:^(bool inProgress, NSNumber *roundNumber, NSNumber *subCourseId, NSString *teeboxname) {
        if (inProgress) {
            isRoundInProgress = inProgress;
            [settings setroundId:roundNumber];
            [settings setsubCourseId:subCourseId];
            userSelectedTeebox = [[NSString alloc]initWithString:teeboxname];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self loadDataToCountinueRound:roundNumber inSubcourse:subCourseId];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self resetAllFields];
            [self loadDataToSetUpNewRound];
            }
    }];
}

-(void)loadDataUserAcceptedInvitation
{
    GameSettings * settings = [GameSettings sharedSettings];
    NSString * invitationToken = [settings invitationToken];
    NSLog(@"InvitationToken: %@", invitationToken);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getRoundInfoForInvitation:invitationToken success:^(NSNumber *roundId) {
        if(roundId == nil || roundId == (NSNumber *)[NSNull null]){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;}
       
        [settings setroundId:roundId];
        [self getRoundOptionsForRoundId:[settings roundId] Completion:^(RoundMetaData *currRound) {
            if(roundId == nil || roundId == (NSNumber *)[NSNull null]){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                return ;}
            self.roundInfo = currRound;
            
            // Saving round options in round.
            GameSettings * gameSettings = [GameSettings sharedSettings];
            [gameSettings setsubCourseId:currRound.activeCourse.itemId];
            
            //Also setting current subCourse
            [gameSettings setsubCourse:currRound.activeCourse];
            [gameSettings setgameType:currRound.activeGameType];
            [gameSettings setscoreType:currRound.activeScoreType];
            
            currentItemsIndropdown = DropDownContainsItemsSubcourses;
            [self setSelectedItemToLocalItem:self.roundInfo.activeCourse];
            currentItemsIndropdown = DropDownContainsItemsGametype;
            [self setSelectedItemToLocalItem:self.roundInfo.activeGameType];
            currentItemsIndropdown = DropDownContainsItemsScoring;
            [self setSelectedItemToLocalItem:self.roundInfo.activeScoreType];
            currentItemsIndropdown = DropDownContainsItemsTeeboxes;
            
            [self setSelectedItemToLocalItem:[[[[self.roundInfo.activeCourse holes] firstObject] teeboxes] firstObject]];
            
            
            // Initiate & Start round
            [self updateSettingsForRound:[settings roundId] subCourseId:[[settings subCourse] itemId] gameType:[[settings gameType] itemId] scoreType:[[settings scoreType] itemId] teebox:[[settings teebox] itemId] success:^(NSNumber *roundId) {
            
                // Now start the round.
                [self startRoundWithId:[gameSettings roundId] subcourseId:[[settings subCourse] itemId] success:^(NSNumber *roundid) {
                    [self getPlayersListForRoundId:[gameSettings roundId] success:^(NSArray *playersList) {
                        if([self.playersInRound count] > 0) [self.playersInRound removeAllObjects];
                        [self.playersInRound addObjectsFromArray:playersList];
                        [self.playersTable reloadData];
                        [self showPlayerTable:YES showStartBtn:YES isStartTitleContinue:YES showAddplyerbtn:NO];
                        // hide hud.
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }];
                }];
            }];
        }];
    }];
}

-(void)loadDataToSetUpNewRound{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getAllRoundOptionsForCurrentCourse:^(RoundMetaData *roundData) {
        self.roundInfo = roundData;
        [self showPlayerTable:NO showStartBtn:YES isStartTitleContinue:NO showAddplyerbtn:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void) resetAllFields{
    self.selectedSubCourse = nil;
    self.selectedTeeBox = nil;
    self.selectedGameType = nil;
    self.selectedScoreType = nil;
    self.lblSelectCourse.text = @"SELECT";
    self.lblSelectGameType.text = @"SELECT";
    self.lblSelectScoring.text = @"SELECT";
    self.lblSelectTeeBox.text = @"SELECT";
}


-(void)loadDataToCountinueRound:(NSNumber *)roundId inSubcourse:(NSNumber *)subcourseId {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getPlayersListForRoundId:roundId success:^(NSArray *playersList) {
        if([self.playersInRound count] > 0) [self.playersInRound removeAllObjects];
        [self.playersInRound addObjectsFromArray:playersList];
        [self.playersTable reloadData];
        
        // To set the already selected options for current round.
        [self getRoundOptionsForRoundId:roundId Completion:^(RoundMetaData *currRound) {
            if(roundId == nil || roundId == (NSNumber *)[NSNull null]){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                return ;}
            self.roundInfo = currRound;
            
            // Saving round options in round.
            GameSettings * gameSettings = [GameSettings sharedSettings];
            [gameSettings setsubCourseId:currRound.activeCourse.itemId];
            
            
            currentItemsIndropdown = DropDownContainsItemsSubcourses;
            [self setSelectedItemToLocalItem:self.roundInfo.activeCourse];
            
            currentItemsIndropdown = DropDownContainsItemsGametype;
            [self setSelectedItemToLocalItem:self.roundInfo.activeGameType];
            currentItemsIndropdown = DropDownContainsItemsScoring;
            [self setSelectedItemToLocalItem:self.roundInfo.activeScoreType];
            currentItemsIndropdown = DropDownContainsItemsTeeboxes;
            
            [self setSelectedItemToLocalItem:[[[[self.roundInfo.activeCourse holes] firstObject] teeboxes] firstObject]];
            
            // Enable Countinue to Round Button.
            [self showPlayerTable:YES showStartBtn:YES isStartTitleContinue:YES showAddplyerbtn:NO];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }];
}





-(void)handleNotification:(NSNotification *)notif
{
    if ([[notif name] isEqualToString:kInviteeAcceptedInvitation]) {
        [self loadData];
    }
    
    if([[notif name] isEqualToString:kAppLaunchUserTapInvitationLink])
    {
        [self loadDataUserAcceptedInvitation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
-(void)cancelRound{
    
    if(![[GameSettings sharedSettings] roundId] ||
       ![[GameSettings sharedSettings] subCourseId] ||
       [[GameSettings sharedSettings] roundId]== (NSNumber *)[NSNull null] ||
       [[GameSettings sharedSettings] subCourseId]==(NSNumber *)[NSNull null]){
        [self showAlertNoRoundInProgress];
        [self resetAllFields];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RoundDataServices finishRoundWithBlock:^(bool status, id response) {
        // Navigate to ScoreCard.
        if(status){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[GameSettings sharedSettings] setroundId:(NSNumber *)[NSNull null]];
            [[GameSettings sharedSettings] setsubCourseId:(NSNumber *)[NSNull null]];
            [[GameSettings sharedSettings] setInvitationToken:(NSString *)[NSNull null]];

            [[[UIAlertView alloc] initWithTitle:@"Round Cancelled!" message:@"Current Round is cancelled, you can now start new round." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            [self resetAllFields];
            [self loadDataToSetUpNewRound];
        }
    } failure:^(bool status, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Try Again!" message:@"Can not cancel current round." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];
}

-(void)showAlertNoRoundInProgress{
    [[[UIAlertView alloc] initWithTitle:@"No Round InProgress" message:@"You have finished all rounds." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (IBAction)btnAddPlayersTapped:(id)sender
{
    if (![self validateRoundOptions]){
        [[[UIAlertView alloc] initWithTitle:@"Required Field Missing." message:@"Please select Course, GameType, ScoreType and TeeBox." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
    [RoundDataServices getNewRoundIdWithOptions:@{
                                                  @"subCourseId" : self.selectedSubCourse.itemId,
                                                  @"gameTypeId" : self.selectedGameType.itemId,
                                                  @"scoreTypeId" : self.selectedScoreType.itemId,
                                                  @"teeBoxId" : self.selectedTeeBox.itemId,
                                                  }
                                        success:^(bool status, NSNumber *roundId) {
                                            if (status) {
                                                [[GameSettings sharedSettings] setroundId:roundId];
                                            }
                                        } failure:^(bool status, NSError *error) {
                                            if (status) {
                                                [[[UIAlertView alloc] initWithTitle:@"Failed to create round !" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                                            }
                                        }];
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    
    RoundInviteViewController * roundInviteFriendController = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundInviteViewController"];
    [delegate.appDelegateNavController pushViewController:roundInviteFriendController animated:YES];
    
}

-(BOOL)validateRoundOptions
{
    return (self.selectedSubCourse.itemId != nil) &&
            (self.selectedGameType.itemId != nil) &&
            (self.selectedScoreType.itemId != nil) &&
            (self.selectedTeeBox.itemId != nil);
}

#pragma mark - API Calls

// call this when some one accepts the send invitation & we received a push notif for this.
-(void)getRoundInfoForInvitation:(NSString *)invitation success:(void(^)(NSNumber * roundId))completion
{
    [InvitationServices getInvitationDetail:^(bool status, id invitation){
        if (status) {
            NSNumber * roundId = invitation[@"invitation_round"][@"round_id"];
            completion(roundId);
        }
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
        completion(nil);
    }];
}

-(void)getPlayersListForRoundId:(NSNumber *)roundId success:(void(^)(NSArray * playersList))completion{
    
    if (!roundId) return;
    [RoundDataServices getPlayersInRoundId:roundId success:^(bool status, RoundPlayers *playerData) {
        if (status) {
            completion(playerData.players);
        }
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
        completion(nil);
    }];
}

-(void)getRoundOptionsForRoundId:(NSNumber * )round Completion:(void(^)(RoundMetaData * currRound))completion
{
    [RoundDataServices getRoundInfoForRoundId:round success:^(bool status, Round * mRound) {
        completion(mRound.roundData);
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
        completion(nil);
    }];
}


// call this for is waiting for players.
-(void)getAllRoundOptionsForCurrentCourse:(void(^)(RoundMetaData *roundData))completion{
                     
    [RoundDataServices getRoundData:^(bool status, RoundMetaData *roundData) {
            if (status) {
                    completion(roundData);
                         }
    } failure:^(bool status, GolfrzError *error) {
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
        completion(nil);
    }];
}

-(void)getPreviousRoundStatus:(void(^)(bool inProgress, NSNumber * roundNumber, NSNumber * subCourseId, NSString * selectedteeBox))completion
{

    [RoundDataServices getRoundInProgress:^(bool status, NSNumber *roundNo, NSNumber *subCourseId, NSString *teeboxName) {
        completion(true, roundNo, subCourseId, teeboxName);
    }
    finishedRounds:^(bool status){
        completion(!status, nil, nil, nil);
    }
    failure:^(bool status, GolfrzError *error){
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
        completion(false, nil, nil, nil);
    }];
}

-(void)updateSettingsForRound:(NSNumber *)roundId
                  subCourseId:(NSNumber *)subcourseId
                     gameType:(NSNumber *)gameTypeId
                    scoreType:(NSNumber *)scoreTypeId
                       teebox:(NSNumber *)teeboxId
                      success:(void(^)(NSNumber * roundId))completion
{
    
    NSMutableDictionary * paramDict = [NSMutableDictionary new];
    
    [paramDict setObject:subcourseId forKey:@"subCourseId"];
    [paramDict setObject:gameTypeId forKey:@"gameTypeId"];
    [paramDict setObject:scoreTypeId forKey:@"scoreTypeId"];
    [paramDict setObject:teeboxId forKey:@"teeBoxId"];
    if(roundId != nil) [paramDict setObject:roundId forKey:@"roundId"];
    
    [RoundDataServices getNewRoundIdWithOptions:paramDict success:^(bool status, NSNumber *roundId) {
       if(status) completion(roundId);
    } failure:^(bool status, NSError *error) {
        if (error) {
            [Utilities displayErrorAlertWithMessage:[error localizedDescription]];
        }
    }];
}

-(void)startRoundWithId:(NSNumber *)roundId subcourseId:(NSNumber *)subcourseId success:(void(^)(NSNumber * roundid))completion
{
    [RoundDataServices startNewRoundWithId:roundId subCourseId:subcourseId success:^(bool status, id roundId) {
        if(status) completion(roundId);
    } failure:^(bool status, NSError *error) {
        if(error) [Utilities displayErrorAlertWithMessage:[error localizedDescription]];
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.playersInRound count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"RoundPlayerCell"];
    
    if (customCell == nil) {
        customCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoundPlayerCell"];
    }
    
    User * player = self.playersInRound[indexPath.row];
    NSString * fullName = [NSString stringWithFormat:@"%@ %@", (player.firstName != nil ? player.firstName : @""), (player.lastName != nil ? player.lastName : @"")];
    
    RoundPlayerCell *customViewCell = (RoundPlayerCell *)customCell;
    [customViewCell.lblPlayerName setText:fullName];
    [customViewCell.lblHandicap setText:[player.handicap stringValue]];
    
    //TODO: Player image url
    [customViewCell.imgPlayerPic sd_setImageWithURL:[NSURL URLWithString:nil] placeholderImage:[UIImage imageNamed:@"person_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [customViewCell.imgPlayerPic setRoundedImage:image];
        }
    }];
    
    return customViewCell;
}

-(void)setSelectedItemToLocalItem:(id)item{
   
    GameSettings * pServices = [GameSettings sharedSettings];

    switch (currentItemsIndropdown) {
        case DropDownContainsItemsSubcourses:
            self.selectedSubCourse = item;
            [pServices setsubCourseId:self.selectedSubCourse.itemId];
            [pServices setsubCourse:self.selectedSubCourse];
            [self UpdateTitleForSelectedItem:item label:self.lblSelectCourse];
            break;
        case DropDownContainsItemsScoring:
            self.selectedScoreType = item;
            [pServices setscoreTypeId:self.selectedScoreType.itemId];
            [pServices setscoreType:self.selectedScoreType];
            [self UpdateTitleForSelectedItem:item label:self.lblSelectScoring];
            break;
        case DropDownContainsItemsGametype:
            self.selectedGameType = item;
            [pServices setgameTypeId:self.selectedGameType.itemId];
            [pServices setgameType:self.selectedGameType];
            [self UpdateTitleForSelectedItem:item label:self.lblSelectGameType];
            break;
        case DropDownContainsItemsTeeboxes:
            self.selectedTeeBox = item;
            [pServices setteeboxId:self.selectedTeeBox.itemId];
            [pServices setteebox:self.selectedTeeBox];
            [self UpdateTitleForSelectedItem:item label:self.lblSelectTeeBox];
            break;
        default:
            break;
    }
}

#pragma mark - PopOverView delegate

- (void)popOverView:(PopOverView *)popOverView indexPathForSelectedRow:(NSIndexPath *)indexPath string:(NSString *)string {
    id item = self.dataArray[indexPath.row];
    NSLog(@"%@, selectedItem-id: %@", [item name], [item itemId]);
    [self setSelectedItemToLocalItem:item];
    [self.popOverView dismissPopOverViewAnimated:YES];
}

#pragma mark - ServiceCalls

- (void)updateRoundInfo:(void(^)(void))completionBlock{
    
    [RoundDataServices updateRound:^(bool status, id response) {
        if (status) {
            [[[UIAlertView alloc] initWithTitle:@"Successfully Updated." message:@"Successfully updated the selected options." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            completionBlock();
        }
    } failure:^(bool status, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Please Try Again" message:@"Can not update the round info now, please try again." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil] show];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0: // Cancel button index
            // Do noting let it disappear.
            break;
        case 1:
            [self updateRoundInfo:nil];
            break;
        default:
            break;
    }
}

#pragma mark - UIActions

- (IBAction)btnSelectCourseTapped:(UIButton *)sender {
    
    ([self.dataArray count] > 0 ? [self.dataArray removeAllObjects] : nil );
    
    [self.dataArray addObjectsFromArray:[self.roundInfo subCourses]];
    currentItemsIndropdown = DropDownContainsItemsSubcourses;
    [self presentPopOverViewPointedAtButton:sender];
    //[self presentPopOverWithOptions:nil pointedAtBtn:sender];
}

- (IBAction)btnGameTypeTapped:(UIButton *)sender {
    
    ([self.dataArray count] > 0 ? [self.dataArray removeAllObjects] : nil );
    
    [self.dataArray addObjectsFromArray:[self.roundInfo gameTypes]];
    currentItemsIndropdown = DropDownContainsItemsGametype;
    [self presentPopOverViewPointedAtButton:sender];
    //[self presentPopOverWithOptions:nil pointedAtBtn:sender];
}

- (IBAction)btnScoringTapped:(UIButton *)sender {
    
    ([self.dataArray count] > 0 ? [self.dataArray removeAllObjects] : nil );
    
    
    [self.dataArray addObjectsFromArray:[self.roundInfo scoreTypes]];
    currentItemsIndropdown = DropDownContainsItemsScoring;
    [self presentPopOverViewPointedAtButton:sender];
    //[self presentPopOverWithOptions:nil pointedAtBtn:sender];
}

- (IBAction)btnSelectTeeBoxTapped:(UIButton *)sender {
    
    if (!self.selectedSubCourse) {
        [[[UIAlertView alloc]initWithTitle:@"Course not selected." message:@"Please select course first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    if([self.dataArray count] > 0) [self.dataArray removeAllObjects];
    
    [self.dataArray addObjectsFromArray:[((Hole *)[self.selectedSubCourse holes][0]) teeboxes]];
    currentItemsIndropdown = DropDownContainsItemsTeeboxes;
    [self presentPopOverViewPointedAtButton:sender];
    //[self presentPopOverWithOptions:nil pointedAtBtn:sender];
}

-(void)UpdateTitleForSelectedItem:(id)item label:(id)sender{
    
    UILabel * lbl = sender;
    //[btn setTitle:[item name] forState:UIControlStateNormal];
    [lbl setText:[[item name] capitalizedString]];
}

- (void)presentPopOverViewPointedAtButton:(UIView *)sender {
    self.popOverView.stringDataSource = [self.dataArray valueForKeyPath:@"self.name"];
    CGPoint point = [sender convertPoint:sender.bounds.origin toView:self.view];
    CGFloat bottomPadding = 12;
    [self.popOverView setMinX:CGRectGetMinX(self.roundSettingsView.frame) maxY:point.y - bottomPadding width:CGRectGetWidth(self.roundSettingsView.frame) animated:YES];
    [self.popOverView showPopOverViewAnimated:YES inView:self.view];
}
- (IBAction)btnStartRoundTapped:(UIButton *)sender {
    
    if (![self validateRoundOptions]) {
        [[[UIAlertView alloc] initWithTitle:@"Required Field Missing." message:@"Please select Course, GameType, ScoreType and TeeBox." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
   
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    GameSettings * gameSetting = [GameSettings sharedSettings];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self updateSettingsForRound:[gameSetting roundId] subCourseId:[gameSetting subCourseId] gameType:[[gameSetting gameType] itemId] scoreType:[[gameSetting scoreType] itemId] teebox:[[gameSetting teebox] itemId]
    success:^(NSNumber *roundId) {
        [gameSetting setroundId:roundId];
        
        // Now call Start Round
        [self startRoundWithId:[gameSetting roundId] subcourseId:[gameSetting subCourseId] success:^(NSNumber *roundid) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            HolesMapViewController * holesMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HolesMapViewController"];
            [delegate.appDelegateNavController pushViewController:holesMapViewController animated:YES];
        }];
    }];
}


- (IBAction)editPlayersTapped:(UIButton *)sender
{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    RoundInviteViewController * roundInviteFriendController = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundInviteViewController"];
    [delegate.appDelegateNavController pushViewController:roundInviteFriendController animated:YES];

}
@end
