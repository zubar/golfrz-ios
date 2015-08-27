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
#import <SDWebImage/UIImageView+WebCache.h>

@interface HolesMapViewController (){
    BOOL isDownButtonPressed;
}
@property (nonatomic, strong) NSMutableArray * holesInround;


@end

@implementation HolesMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];

    
    GameSettings * settings = [GameSettings sharedSettings];
    [settings setTotalNumberOfHoles:[NSNumber numberWithInteger:[[[settings subCourse] holes] count]]];
    
    
    if (!self.holesInround) {
        self.holesInround = [[NSMutableArray alloc]initWithCapacity:1];
        [self.holesInround addObjectsFromArray:[[settings subCourse] holes]];
    }else{
        if([self.holesInround count] > 0) [self.holesInround removeAllObjects];
        [self.holesInround addObjectsFromArray:[[settings subCourse] holes]];
    }
    if ([self.holesInround count] <= 9) [self.btnNextHoles setHidden:YES];
    else [self.btnNextHoles setHidden:NO];

    
    isDownButtonPressed = FALSE;
    NSDictionary *navTitleAttributes =@{
                                        NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.0],
                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                        };
    
    self.navigationItem.title = @"FRONT NINE";
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.holesInround count];
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
    
    Hole * aHole = self.holesInround[indexPath.row];
    HoleMapCell *customCell = (HoleMapCell *)cell;
    customCell.lblHoleNo.text = [[aHole holeNumber] stringValue];
    customCell.lblPar.text = [[aHole par] stringValue];
    [customCell.imgHoleMao sd_setImageWithURL:[NSURL URLWithString:[aHole imagePath]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [customCell.imgHoleMao setImage:image];
    }];
    return customCell;
}

#pragma mark - Navigation
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    
    RoundViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundViewController"];
    controller.holeNumberPlayed = [NSNumber numberWithInteger:indexPath.row];
    [appDelegate.appDelegateNavController pushViewController:controller animated:YES];
    return;
}

#pragma mark - UIActions
- (IBAction)btnNextHolesTapped:(UIButton *)sender {
    if ([self.holesInround count] < 10) return;
    
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
        self.navigationItem.title = @"BACK NINE";
        NSIndexPath *indexPathToScroll = [NSIndexPath indexPathForItem:1 inSection:0];
        [self.holeCollectionView scrollToItemAtIndexPath:indexPathToScroll atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        isDownButtonPressed = FALSE;
    }
    
}
@end
