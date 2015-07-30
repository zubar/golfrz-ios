//
//  HolesMapViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/6/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "HolesMapViewController.h"
#import "HoleMapCell.h"
#import "AppDelegate.h"
#import "RoundViewController.h"
#import "GameSettings.h"
#import "SubCourse.h"
#import "Hole.h"

@interface HolesMapViewController (){
    BOOL isDownButtonPressed;
}
@property (nonatomic, strong) NSMutableArray * firstNineHoles;


@end

@implementation HolesMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.firstNineHoles) {
        self.firstNineHoles = [[NSMutableArray alloc]initWithCapacity:1];
        GameSettings * settings = [GameSettings sharedSettings];
        [self.firstNineHoles addObjectsFromArray:[[settings subCourse] holes]];
    }
    isDownButtonPressed = FALSE;
    NSDictionary *navTitleAttributes =@{
                                        NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.0],
                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                        };
    
    self.navigationItem.title = @"FIRST NINE";
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.firstNineHoles count];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    return CGSizeMake((appFrame.size.width - 20) / 3, 140);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HoleMapCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    HoleMapCell *customCell = (HoleMapCell *)cell;
    customCell.lblHoleNo.text = [[self.firstNineHoles[indexPath.row] holeNumber] stringValue];
    customCell.lblPar.text = [[self.firstNineHoles[indexPath.row] par] stringValue];
    return customCell;
}

#pragma mark - Navigation
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    
    RoundViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundViewController"];
    controller.holeNumberPlayed = [NSNumber numberWithInteger:indexPath.row + 1];
    [appDelegate.appDelegateNavController pushViewController:controller animated:YES];
}

#pragma mark - UIActions
- (IBAction)btnNextHolesTapped:(UIButton *)sender {
    if ([self.firstNineHoles count] < 10) return;
    
    if (!isDownButtonPressed) {
        UIImage *buttonToDisplay = [UIImage imageNamed:@"ChooseHole_Up"];
        [self.btnNextHoles setImage:buttonToDisplay forState:UIControlStateNormal];
        self.navigationItem.title = @"LAST NINE";
        NSIndexPath *indexPathToScroll = [NSIndexPath indexPathForItem:10 inSection:0];
        [self.holeCollectionView scrollToItemAtIndexPath:indexPathToScroll atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        isDownButtonPressed = TRUE;
    }else{
        UIImage *buttonToDisplay = [UIImage imageNamed:@"ChooseHole_Down"];
        [self.btnNextHoles setImage:buttonToDisplay forState:UIControlStateNormal];
        self.navigationItem.title = @"FIRST NINE";
        NSIndexPath *indexPathToScroll = [NSIndexPath indexPathForItem:1 inSection:0];
        [self.holeCollectionView scrollToItemAtIndexPath:indexPathToScroll atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        isDownButtonPressed = FALSE;
    }
    
    
}
@end
