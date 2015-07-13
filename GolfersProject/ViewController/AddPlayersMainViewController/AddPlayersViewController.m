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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [RoundDataServices getRoundData:^(bool status, RoundData *roundData) {
        self.roundInfo = roundData;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(bool status, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}
/*
-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:YES];
    
}
*/

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

- (IBAction)btnAddPlayersTapped:(id)sender {
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];

    RoundInviteViewController * roundInviteFriendController = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundInviteViewController"];
    [delegate.appDelegateNavController pushViewController:roundInviteFriendController animated:YES];
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
    
    self.popTipView = nil;
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
