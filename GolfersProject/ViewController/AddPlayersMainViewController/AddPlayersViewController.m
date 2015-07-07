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
#import "Teebox.h"

#import "RoundDataServices.h"
#import "MBProgressHUD.h"
#import "ScoreSelectionView.h"

@interface AddPlayersViewController ()
@property (nonatomic, strong) SubCourse * selectedSubCourse;
@property (nonatomic, strong) GameType * selectedGameType;
@property (nonatomic, strong) ScoreType * selectedScoreType;
@property (nonatomic, strong) Teebox * selectedTeeBox;

@property (nonatomic, strong) CMPopTipView * popTipView;

@end

@implementation AddPlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [RoundDataServices getRoundData:^(bool status, RoundData *roundData) {
        self.roundInfo = roundData;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(bool status, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [delegate.appDelegateNavController setNavigationBarHidden:YES];
    
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

- (IBAction)btnAddPlayersTapped:(id)sender {
    
    DropdownView * mScoreView = [[DropdownView alloc]init];
    mScoreView.dataSource = self;
    mScoreView.delegate = self;
    [mScoreView setBackgroundColor:[UIColor whiteColor]];
    
    
    // Toggle popTipView when a standard UIButton is pressed
    if (nil == self.popTipView) {
        self.popTipView = [[CMPopTipView alloc] initWithCustomView:mScoreView];
        self.popTipView.delegate = self;
        self.popTipView.backgroundColor = [UIColor whiteColor];
        [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
    }
    else {
        // Dismiss
        [self.popTipView dismissAnimated:YES];
        self.popTipView = nil;
    }
}

// TODO: Testing code
-(NSArray *)dataArrayForCells{
    
    return [NSArray arrayWithObjects:@"Course Name", @"Course Two", @"Course Two",@"Course Two",@"Course Two",@"Course Two",@"Course Two", nil];
}

-(void)selectedItemForCell:(id)item{
    
    NSLog(@"%@", item);
    [self.popTipView dismissAnimated:YES];
    
}

#pragma mark - CMPopTipView

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView{

}


@end
