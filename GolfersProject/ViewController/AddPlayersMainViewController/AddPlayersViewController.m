//
//  AddPlayersViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/1/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "AddPlayersViewController.h"
#import "AppDelegate.h"

#import "SubCourse.h"
#import "GameType.h"
#import "ScoreType.h"
#import "Hole.h"
#import "Teebox.h"

#import "RoundDataServices.h"
#import "MBProgressHUD.h"
#import "ScoreSelectionView.h"
#import "RoundInviteViewController.h"
#import "RoundDataServices.h"

#import "PersistentServices.h"

@interface AddPlayersViewController (){
    DropDownContainsItems currentItemsIndropdown;
}
@property (nonatomic, strong) SubCourse * selectedSubCourse;
@property (nonatomic, strong) GameType * selectedGameType;
@property (nonatomic, strong) ScoreType * selectedScoreType;
@property (nonatomic, strong) Teebox * selectedTeeBox;

@property (nonatomic, strong) CMPopTipView * popTipView;

@property (nonatomic, strong) NSMutableArray * dataArray;
@end


@implementation AddPlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [[NSMutableArray alloc]init];
    currentItemsIndropdown = DropDownContainsItemsNone;
    
    // Remove left button
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    // Right bar button
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [RoundDataServices getRoundData:^(bool status, RoundData *roundData) {
        self.roundInfo = roundData;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(bool status, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
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
    [mScoreView setBackgroundColor:[UIColor whiteColor]];
    
    
    // Toggle popTipView when a standard UIButton is pressed
    if (nil == self.popTipView) {
        self.popTipView = [[CMPopTipView alloc] initWithCustomView:mScoreView];
        self.popTipView.delegate = self;
        self.popTipView.backgroundColor = [UIColor whiteColor];
        [self.popTipView setPreferredPointDirection:PointDirectionDown];
        [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
    }
    else {
        // Dismiss
        [self.popTipView dismissAnimated:YES];
        self.popTipView = nil;
        mScoreView = nil;
    }

}
@end
