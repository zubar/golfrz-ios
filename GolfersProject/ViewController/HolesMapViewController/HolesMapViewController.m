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
        [self.firstNineHoles addObjectsFromArray:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16", nil]];
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
    customCell.lblHoleNo.text = [self.firstNineHoles objectAtIndex:indexPath.row];
    customCell.lblPar.text = [self.firstNineHoles objectAtIndex:indexPath.row];
    return customCell;
}


-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath: %@", indexPath);

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    
    RoundViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundViewController"];
    controller.holeNumberPlayer = [NSNumber numberWithInteger:indexPath.row];
    [appDelegate.appDelegateNavController pushViewController:controller animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnNextHolesTapped:(UIButton *)sender {
    
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
