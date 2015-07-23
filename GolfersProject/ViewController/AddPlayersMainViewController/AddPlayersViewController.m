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
#import "PersistentServices.h"
#import "HolesMapViewController.h"
#import "RoundDataServices.h"
#import "RoundPlayers.h"

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
    self.dataArray = [[NSMutableArray alloc]init];
    self.playersInRound = [[NSMutableArray alloc] init];
    currentItemsIndropdown = DropDownContainsItemsNone;
    
    // Remove left button
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    // Right bar button
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (![[PersistentServices sharedServices] isRoundInProgress]) {
      
        [RoundDataServices getRoundData:^(bool status, RoundMetaData *roundData) {
            self.roundInfo = roundData;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(bool status, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        }];
    }else{
        //TODO: don't allow editing the subcourse.
    }
    
    /*
     This notification is posted by PushManager class, it informs that someone has accepted the invitation for round.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:kInviteeAcceptedInvitation object:nil];
    // Check if the controller is launched due to invitation Acceptance.
    if ([[SharedManager sharedInstance] isInvitationAccepted]) {
        PersistentServices * persistentStore = [PersistentServices sharedServices];
        [persistentStore setWaitingForPlayers:NO];
        [persistentStore setIsRoundInProgress:YES];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      
            [InvitationServices getInvitationDetail:^(bool status, id invitation) {
                NSNumber * roundId = invitation[@"invitation_round"][@"round_id"];
                [persistentStore setCurrentRoundId:roundId];
                [self loadRoundDetailsForRoundId:roundId Completion:^{
                    
                    [self updateViewsRoundInProgressCompletion:^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }];
                    
                }];
            } failure:^(bool status, NSError *error) {
                // <#code#>
            }];

        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
  
    PersistentServices * persistentStore = [PersistentServices sharedServices];
   
    // default value
    [self hidePlayersContainerView:YES];
    
    // updating views by check use-cases.
    if ([persistentStore isWaitingForPlayers]) {
        [self updateViewsWaitingPlayerStateCompletion:^{
            //
        }];
    }else
        if ([persistentStore isRoundInProgress]) {
            [self updateViewsRoundInProgressCompletion:^{
                //
            }];
        }
}

-(void)updateViewsWaitingPlayerStateCompletion:(void(^)(void))handler{

    [self loadPlayersListCompletion:^{
        handler();
    }];
    [self.playersTableContainerView setHidden:NO];
    [self.btnStartRound setTitle:@"Start Round" forState:UIControlStateNormal];
    [self.btnStartRound setHidden:YES];
    [self.addPlayerContainerView setHidden:YES];
}
-(void)updateViewsRoundInProgressCompletion:(void(^)(void))completionHandler{

    [self loadPlayersListCompletion:^{
        [self.playersTable reloadData];
        completionHandler();
    }];
    [self.btnStartRound setTitle:@"Continue To Round" forState:UIControlStateNormal];
    [self.btnStartRound setHidden:NO];
    [self.playersTableContainerView setHidden:NO];
    [self.addPlayerContainerView setHidden:YES];
}

-(void)loadPlayersListCompletion:(void(^)(void))completion{
   
    //TODO: send call to get players list.
     NSNumber * roundId = [[PersistentServices sharedServices] currentRoundId];
    
    [RoundDataServices getPlayersInRoundId:roundId success:^(bool status, RoundPlayers *playerData) {
        if (status) {
            [self.playersInRound removeAllObjects];
            [self.playersInRound addObjectsFromArray:playerData.players];
            completion();
        }
    } failure:^(bool status, NSError *error) {
        if (status) {
            NSLog(@"%@", error);
        }
    }];
}


-(void)loadRoundDetailsForRoundId:(NSNumber * )round Completion:(void(^)(void))completion{
    
    [RoundDataServices getRoundInfoForRoundId:round success:^(bool status, Round * mRound) {
        RoundMetaData * currRound = mRound.roundData;
        
        [self.btnSelectCourse setTitle:currRound.name forState:UIControlStateNormal];
     //   [self.btnSelectGametype settit]
       //TODO: set selected model objects as well.
        
    } failure:^(bool status, NSError *error) {
       // <#code#>
    }];
    
}

-(void)handleNotification:(NSNotification *)notif{

    if ([[notif name] isEqualToString:kInviteeAcceptedInvitation]) {
      
        if ([[PersistentServices sharedServices] isRoundInProgress]) {
            [self updateViewsRoundInProgressCompletion:^{
                //
            }];
        }else
            if ([[PersistentServices sharedServices] isWaitingForPlayers]) {
                
                [[PersistentServices sharedServices] setWaitingForPlayers:NO];
                [self updateViewsWaitingPlayerStateCompletion:^{
                    //
                }];
            }
    }
}

-(void)hidePlayersContainerView:(BOOL )yesNo{
    
    [self.playersTableContainerView setHidden:yesNo];
    [self.addPlayerContainerView setHidden:!yesNo];
    [self.btnStartRound setHidden:yesNo];
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
                                                [[PersistentServices sharedServices] setCurrentRoundId:roundId];
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
    return self.selectedSubCourse.itemId && self.selectedGameType.itemId && self.selectedScoreType.itemId && self.selectedTeeBox.itemId;
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
    
    switch (currentItemsIndropdown) {
        case DropDownContainsItemsSubcourses:
            self.selectedSubCourse = item;
            [self UpdateTitleForSelectedItem:item button:self.btnSelectCourse];
            break;
        case DropDownContainsItemsScoring:
            self.selectedScoreType = item;
            [self UpdateTitleForSelectedItem:item button:self.btnSelectScoretype];
            break;
        case DropDownContainsItemsGametype:
            self.selectedGameType = item;
            [self UpdateTitleForSelectedItem:item button:self.btnSelectGametype];
            break;
        case DropDownContainsItemsTeeboxes:
            self.selectedTeeBox = item;
            [self UpdateTitleForSelectedItem:item button:self.btnSelectTeebox];
            break;
        default:
            break;
    }
    
    [self.popTipView dismissAnimated:YES];
}


#pragma mark - CMPopTipView
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView{
    [self saveRoundInfo];
    self.popTipView = nil;
}

-(void)saveRoundInfo{
    
    PersistentServices * pServices = [PersistentServices sharedServices];
    //
    [pServices setCurrentSubCourseId:self.selectedSubCourse.itemId];
    [pServices setCurrentGameTypeId:self.selectedGameType.itemId];
    [pServices setCurrentScoreTypeId:self.selectedScoreType.itemId];
    [pServices setcurrentTeebox:self.selectedTeeBox.itemId];
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


-(void)UpdateTitleForSelectedItem:(id)item button:(id)sender{
    
    UIButton * btn = sender;
    [btn.titleLabel setText:[item name]];
    
//    [sender sizeToFit];
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width, 0, btn.imageView.frame.size.width);
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.frame.size.width, 0, -btn.titleLabel.frame.size.width);
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
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    
    HolesMapViewController * holesMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HolesMapViewController"];
    [delegate.appDelegateNavController pushViewController:holesMapViewController animated:YES];
}


- (IBAction)editPlayersTapped:(UIButton *)sender {
    
    
}
@end
