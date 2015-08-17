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
#import "InvitationManager.h"

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
}
@property (nonatomic, strong) SubCourse * selectedSubCourse;
@property (nonatomic, strong) GameType * selectedGameType;
@property (nonatomic, strong) ScoreType * selectedScoreType;
@property (nonatomic, strong) Teebox * selectedTeeBox;

@property (nonatomic, strong) CMPopTipView * popTipView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) NSMutableArray * playersInRound;
@end


@implementation AddPlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];

    
    self.dataArray = [[NSMutableArray alloc]init];
    self.playersInRound = [[NSMutableArray alloc] init];
    currentItemsIndropdown = DropDownContainsItemsNone;
    
    
    // Right bar button
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    /*
     This notification is posted by PushManager class, it informs that someone has accepted the invitation for round.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:kInviteeAcceptedInvitation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:kAppLaunchInvitationReceived object:nil];
}


-(void)showViewsRoundInProgressOrWaitingForPlayers{
    
    [self.playersTableContainerView setHidden:NO];
    [self.addPlayerContainerView setHidden:YES];
    [self.btnStartRound setTitle:@"CONTINUE TO ROUND" forState:UIControlStateNormal];
    [self.btnStartRound setHidden:NO];
    ( [self.playersInRound count] > 1 ? [self.btnStartRound setHidden:NO] : [self.btnStartRound setHidden:YES]);

}

// if invitee accepts the invitation, there will be two players in the round and invitee can start the round now.
-(void)showViewsAcceptedInvitation{
    
    [self.playersTableContainerView setHidden:NO];
    [self.addPlayerContainerView setHidden:YES];
    [self.btnStartRound setTitle:@"START ROUND" forState:UIControlStateNormal];
    [self.btnStartRound setHidden:NO];
    
}

-(void)showViewsAddPlayers{
    
    [self.playersTableContainerView setHidden:YES];
    [self.addPlayerContainerView setHidden:NO];
    [self.btnStartRound setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self loadData];
}

-(void)loadData{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    
    GameSettings * persistentStore = [GameSettings sharedSettings];
    InvitationManager * invitationManager = [InvitationManager sharedInstance];

     __block NSNumber * roundId = [[GameSettings sharedSettings] roundId];

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // If no invitation Token, it mean the user can't be the invitee.
    if(![[InvitationManager sharedInstance] invitationToken]){
        
        // if no round inProgress & no waiting for players, want to Invite players to start round.
        if (![persistentStore isRoundInProgress] && ![persistentStore isWaitingForPlayers]) {
                [self showViewsAddPlayers];
                [self getAvailableRoundOptions:^{
                    [self.playersTable reloadData];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }else
            if ([persistentStore isRoundInProgress]) {
                
                [self showViewsRoundInProgressOrWaitingForPlayers];
                [self loadRoundDetailsForRoundId:roundId Completion:^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                }];
                [self loadPlayersListCompletion:^{
                    [self.playersTable reloadData];
                    [self showViewsRoundInProgressOrWaitingForPlayers];

                }];
            }else
                 if([persistentStore isWaitingForPlayers]){
                    
                     [self showViewsRoundInProgressOrWaitingForPlayers];
                     [self loadPlayersListCompletion:^{
                         [self.playersTable reloadData];
                         [self showViewsRoundInProgressOrWaitingForPlayers];
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                     }];
                 }
    }else{   // User has received atleast one invitation.
        if (![invitationManager isInvitationAccepted]){
            // Don't know if this case will be evaluated.
            
            [persistentStore setWaitingForPlayers:NO];
            [persistentStore setIsRoundInProgress:YES];
            
            [self loadDataInvitationAcceptedByInvitee:^{
                [self showViewsRoundInProgressOrWaitingForPlayers];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }else
            if ([invitationManager isInvitationAccepted]) {
                
                [self showViewsRoundInProgressOrWaitingForPlayers];
                
                [self loadDataInvitationAcceptedByInvitee:^{
                    roundId = [[GameSettings sharedSettings] roundId];
                    
                    [self showViewsRoundInProgressOrWaitingForPlayers];
                   // [self loadRoundDetailsForRoundId:roundId Completion:^{
                        
                        [self loadPlayersListCompletion:^{
                            [self.playersTable reloadData];
                            [self showViewsRoundInProgressOrWaitingForPlayers];
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        }];
                   // }];
                }];
            }
    }
}



-(void)updateViewsRoundInProgressCompletion:(void(^)(void))completionHandler{
    
    [self loadPlayersListCompletion:^{
        [self.playersTable reloadData];
        completionHandler();
    }];
    [self.btnStartRound setTitle:@"CONTINUE TO ROUND" forState:UIControlStateNormal];
    [self.btnStartRound setHidden:NO];
    [self.playersTableContainerView setHidden:NO];
    [self.addPlayerContainerView setHidden:YES];
}


-(void)handleNotification:(NSNotification *)notif{
    
    if ([[notif name] isEqualToString:kInviteeAcceptedInvitation] || [[notif name] isEqualToString:kAppLaunchInvitationReceived]) {
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)popSelf{
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.appDelegateNavController popViewControllerAnimated:YES];
}

- (IBAction)btnAddPlayersTapped:(id)sender {
    
    
    if (![self validateRoundOptions]) {
        [[[UIAlertView alloc] initWithTitle:@"Required Field Missing." message:@"Please select SubCourse, GameType, ScoreType and TeeBox." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
    [self saveRoundInfo];
    
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
                                                [[[UIAlertView alloc] initWithTitle:@"Failed to create round !" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                                            }
                                        }];
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    
    RoundInviteViewController * roundInviteFriendController = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundInviteViewController"];
    [delegate.appDelegateNavController pushViewController:roundInviteFriendController animated:YES];
    
}

-(BOOL)validateRoundOptions{
    return (self.selectedSubCourse.itemId != nil) &&
            (self.selectedGameType.itemId != nil) &&
            (self.selectedScoreType.itemId != nil) &&
            (self.selectedTeeBox.itemId != nil);
}

#pragma mark - API Calls

// call this when some one accepts the send invitation & we received a push notif for this.
-(void)loadDataInvitationAcceptedByInvitee:(void(^)(void))completion{
    
    GameSettings * persistentStore = [GameSettings sharedSettings];
    
    [InvitationServices getInvitationDetail:^(bool status, id invitation) {
        
        if (status) {
            NSNumber * roundId = invitation[@"invitation_round"][@"round_id"];
            [persistentStore setroundId:roundId];
            [self loadRoundDetailsForRoundId:roundId Completion:^{
                completion();
            }];
        }
        
    } failure:^(bool status, NSError *error) {
        completion();
    }];
}

-(void)loadPlayersListCompletion:(void(^)(void))completion{
    
    NSNumber * roundId = [[GameSettings sharedSettings] roundId];
    if (!roundId) {
        return;
    }
    
    [RoundDataServices getPlayersInRoundId:roundId success:^(bool status, RoundPlayers *playerData) {
        if (status) {
            [self.playersInRound removeAllObjects];
            [self.playersInRound addObjectsFromArray:playerData.players];
            completion();
        }
    } failure:^(bool status, GolfrzError *error) {
        completion();
    }];
}

-(void)loadRoundDetailsForRoundId:(NSNumber * )round Completion:(void(^)(void))completion{
    
    [RoundDataServices getRoundInfoForRoundId:round success:^(bool status, Round * mRound) {
       
        RoundMetaData * currRound = mRound.roundData;
        self.roundInfo = currRound;
        
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
        [self setSelectedItemToLocalItem:[[[[[self.roundInfo.subCourses firstObject] holes] firstObject] teeboxes] firstObject]];
        
        completion();
        
    } failure:^(bool status, GolfrzError *error) {
        completion();

    }];
    
}


// call this for is waiting for players.
-(void)getAvailableRoundOptions:(void(^)(void))completion{
                     
    [RoundDataServices getRoundData:^(bool status, RoundMetaData *roundData) {
            if (status) {
                    self.roundInfo = roundData;
                    completion();
                         }
    } failure:^(bool status, GolfrzError *error) {
        completion();
        [Utilities displayErrorAlertWithMessage:[error errorMessage]];
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
    NSString * fullName = [NSString stringWithFormat:@"%@%@", (player.firstName != nil ? player.firstName : @""), (player.lastName != nil ? player.lastName : @"")];
    
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

-(NSArray *)dataArrayForCells{
    return self.dataArray;
}

-(void)selectedItemForCell:(id)item{
    
    NSLog(@"%@, selectedItem-id: %@", [item name], [item itemId]);
    [self setSelectedItemToLocalItem:item];
    [self.popTipView dismissAnimated:YES];
}

-(void)setSelectedItemToLocalItem:(id)item{
   
    switch (currentItemsIndropdown) {
        case DropDownContainsItemsSubcourses:
            self.selectedSubCourse = item;
            [self UpdateTitleForSelectedItem:item label:self.lblSelectCourse];
            break;
        case DropDownContainsItemsScoring:
            self.selectedScoreType = item;
            [self UpdateTitleForSelectedItem:item label:self.lblSelectScoring];
            break;
        case DropDownContainsItemsGametype:
            self.selectedGameType = item;
            [self UpdateTitleForSelectedItem:item label:self.lblSelectGameType];
            break;
        case DropDownContainsItemsTeeboxes:
            self.selectedTeeBox = item;
            [self UpdateTitleForSelectedItem:item label:self.lblSelectTeeBox];
            break;
        default:
            break;
    }
}

#pragma mark - CMPopTipView
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView{
    [self saveRoundInfo];
    self.popTipView = nil;
}

-(void)saveRoundInfo{
    
    GameSettings * pServices = [GameSettings sharedSettings];
    //
    [pServices setsubCourseId:self.selectedSubCourse.itemId];
    [pServices setgameTypeId:self.selectedGameType.itemId];
    [pServices setscoreTypeId:self.selectedScoreType.itemId];
    [pServices setteeboxId:self.selectedTeeBox.itemId];
}


#pragma mark - ServiceCalls

- (void)updateRoundInfo:(void(^)(void))completionBlock{
    
    [RoundDataServices updateRound:^(bool status, id response) {
        if (status) {
            [[[UIAlertView alloc] initWithTitle:@"Successfully Updated." message:@"Successfully updated the selected options." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
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
    [self presentPopOverWithOptions:nil pointedAtBtn:sender];
}

- (IBAction)btnGameTypeTapped:(UIButton *)sender {
    
    ([self.dataArray count] > 0 ? [self.dataArray removeAllObjects] : nil );
    
    [self.dataArray addObjectsFromArray:[self.roundInfo gameTypes]];
    currentItemsIndropdown = DropDownContainsItemsGametype;
    [self presentPopOverWithOptions:nil pointedAtBtn:sender];
}

- (IBAction)btnScoringTapped:(UIButton *)sender {
    
    ([self.dataArray count] > 0 ? [self.dataArray removeAllObjects] : nil );
    
    
    [self.dataArray addObjectsFromArray:[self.roundInfo scoreTypes]];
    currentItemsIndropdown = DropDownContainsItemsScoring;
    
    [self presentPopOverWithOptions:nil pointedAtBtn:sender];
}

- (IBAction)btnSelectTeeBoxTapped:(UIButton *)sender {
    
    ([self.dataArray count] > 0 ? [self.dataArray removeAllObjects] : nil );
    
    if (!self.selectedSubCourse) {
        [[[UIAlertView alloc]initWithTitle:@"Subcourse not selected." message:@"Please select subcourse first." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    [self.dataArray addObjectsFromArray:[((Hole *)[self.selectedSubCourse holes][0]) teeboxes]];
    currentItemsIndropdown = DropDownContainsItemsTeeboxes;
    
    [self presentPopOverWithOptions:nil pointedAtBtn:sender];
}




-(void)UpdateTitleForSelectedItem:(id)item label:(id)sender{
    
    UILabel * lbl = sender;
    //[btn setTitle:[item name] forState:UIControlStateNormal];
    [lbl setText:[item name]];
    //[btn.titleLabel setText:[item name]];
}

-(void)presentPopOverWithOptions:(NSArray *)options pointedAtBtn:(id)sender{
    
    DropdownView * mScoreView = [[DropdownView alloc]init];
    mScoreView.dataSource = self;
    mScoreView.delegate = self;
    [mScoreView setFrame:CGRectMake(mScoreView.frame.origin.x, mScoreView.frame.origin.y, mScoreView.frame.size.width, 100)];
    [mScoreView setBackgroundColor:[UIColor whiteColor]];
    
    // Toggle popTipView when a standard UIButton is pressed
    if (nil == self.popTipView) {
        self.popTipView = [[CMPopTipView alloc] initWithCustomView:mScoreView];
        self.popTipView.delegate = self;
        self.popTipView.backgroundColor = [UIColor whiteColor];
        [self.popTipView setPreferredPointDirection:PointDirectionDown];
        [self.popTipView setCornerRadius:5.0f];
        //[self.popTipView setBackgroundColor:[UIColor darkGrayColor]];
        [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
    }
    else {
        // Dismiss
        [self.popTipView dismissAnimated:YES];
        self.popTipView = nil;
        mScoreView = nil;
    }
}

- (IBAction)btnStartRoundTapped:(UIButton *)sender {
    
    if (![self validateRoundOptions]) {
        [[[UIAlertView alloc] initWithTitle:@"Required Field Missing." message:@"Please select SubCourse, GameType, ScoreType and TeeBox." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    [self saveRoundInfo];
    InvitationManager * invitationManager = [InvitationManager sharedInstance];
    if ([invitationManager isInvitationAccepted])
        [self startRoundInvitee];
    else
        [self startRoundInviter];
}

// Inviter only needs to call start round api.
-(void)startRoundInviter{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GameSettings * persistentStore = [GameSettings sharedSettings];
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    
    // Assuming game settings has valid round ID, GameTypeID, etc.
    [RoundDataServices updateRound:^(bool status, id response) {
        if (status)
            [RoundDataServices startNewRoundWithId:[persistentStore roundId]
                                       subCourseId:[persistentStore subCourseId]
                                           success:^(bool status, id roundId) {
                                               if (status) {
                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                   HolesMapViewController * holesMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HolesMapViewController"];
                                                   [delegate.appDelegateNavController pushViewController:holesMapViewController animated:YES];
                                                   return ;
                                               }
                                           } failure:^(bool status, NSError *error) {
                                               [[[UIAlertView alloc]initWithTitle:@"Try Again" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                                           }];
    } failure:^(bool status, NSError *error) {
        NSLog(@"Failed : %@" , [error localizedDescription]);
    }];
}

// Invitee first needs to call new round API then start round.
-(void)startRoundInvitee{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GameSettings * persistentStore = [GameSettings sharedSettings];
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    
    
    [RoundDataServices updateRound:^(bool status, id response) {
        if(status)
            [RoundDataServices startNewRoundWithId:[persistentStore roundId]
                                       subCourseId:[persistentStore subCourseId]
                                           success:^(bool status, id roundId) {
                                               if (status) {
                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                   HolesMapViewController * holesMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HolesMapViewController"];
                                                   [delegate.appDelegateNavController pushViewController:holesMapViewController animated:YES];
                                                   return ;
                                               }
                                           } failure:^(bool status, NSError *error) {
                                               [[[UIAlertView alloc]initWithTitle:@"Try Again" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                                           }];
    } failure:^(bool status, NSError *error) {
        NSLog(@"Error-RoundInvitee: %@", error);
    }];
    
    
}

- (IBAction)editPlayersTapped:(UIButton *)sender {
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    
    RoundInviteViewController * roundInviteFriendController = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundInviteViewController"];
    [delegate.appDelegateNavController pushViewController:roundInviteFriendController animated:YES];

}
@end
