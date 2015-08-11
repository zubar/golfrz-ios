//
//  ScoreBoardViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "ScoreBoardViewController.h"
#import "ScoreBoardManager.h"
#import "Constants.h"
#import "ScoreCardUser.h"
#import "ScoreCardUserScore.h"
#import "ScoreCardHole.h"
#import "ScoreboardServices.h"
#import "ScoreCard.h"
#import "ScoreBoardBodyCell.h"
#import "ScoreBoardHeaderCell.h"
#import "MBProgressHUD.h"
@interface ScoreBoardViewController (){
    
    NSUInteger numberOfLeftColumns;
    ScoreCard *scoreCard_;
    int parTotal_;
    int parTotal2_;
}


@end

@implementation ScoreBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ScoreBoardManager sharedScoreBoardManager].numberOfSections = 0;
    [ScoreBoardManager sharedScoreBoardManager].numberOfItems = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
//    [ScoreboardServices getScoreCardForRoundId:[NSNumber numberWithInt:466] subCourse:[NSNumber numberWithInt:1] success:^(bool status, id responseObject) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        scoreCard_ = [[ScoreCard alloc] initWithDictionary:responseObject];
//        
//        [ScoreBoardManager sharedScoreBoardManager].numberOfItems = scoreCard_.users.count + [scoreCard_.teeBoxCount intValue]+9;//(int)scoreCard.holesArray.count;
//        [ScoreBoardManager sharedScoreBoardManager].numberOfSections = 18;
//        [ScoreBoardManager sharedScoreBoardManager].scoreCard = scoreCard_;
//        
//        [_rightCollectionView reloadData];
//        
//
//    } failure:^(bool status, NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"Failed");
//    }];
    
    [ScoreboardServices getTestScoreCard:^(bool status, id responseObject) {
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        scoreCard_ = [[ScoreCard alloc] initWithDictionary:responseObject];
        
        [ScoreBoardManager sharedScoreBoardManager].numberOfItems = (int)scoreCard_.users.count + [scoreCard_.teeBoxCount intValue]+2;
        [ScoreBoardManager sharedScoreBoardManager].numberOfSections = (int)scoreCard_.holeCount+5;
        [ScoreBoardManager sharedScoreBoardManager].scoreCard = scoreCard_;
        [self calculateParTotal];
        
        [_rightCollectionView reloadData];
        
    } failure:^(bool status, NSError *error) {
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    numberOfLeftColumns = [[ScoreBoardManager sharedScoreBoardManager].scoreCard.teeBoxCount intValue] + 2;

}
-(void)calculateParTotal
{
    parTotal_ = 0;
    parTotal2_ = 0;
    if (scoreCard_.holeCount >= 9) {
        for (int i = 0; i<9; i++) {
            ScoreCardHole *scoreCardHole = [scoreCard_.holesArray objectAtIndex:i];
            NSNumber *number = scoreCardHole.parValue;
            parTotal_ += [number intValue];
        }
        for (int i = 9; i<18; i++) {
            ScoreCardHole *scoreCardHole = [scoreCard_.holesArray objectAtIndex:i];
            NSNumber *number = scoreCardHole.parValue;
            parTotal2_ += [number intValue];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    scoreCard_ = nil;
    [ScoreBoardManager sharedScoreBoardManager].scoreCard = nil;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (collectionView == _leftCollectionView)
    {
     
        return 0;
    }
    return [ScoreBoardManager sharedScoreBoardManager].numberOfItems;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    if (collectionView == _leftCollectionView)
    {
        return 0;
    }
    return [ScoreBoardManager sharedScoreBoardManager].numberOfSections;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headerCell" forIndexPath:indexPath];
        ScoreBoardHeaderCell *headerCell = (ScoreBoardHeaderCell *)cell;
        if (cell == nil)
        {
            cell = [[UICollectionViewCell alloc]init];
        }
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftColorImage"]];
        if (indexPath.row == 0) {
            headerCell.lblHeading.text = @"Hole";
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UILabel *noLbl = [[UILabel alloc] initWithFrame:CGRectMake(17, 16, 10, 10)];
                [noLbl setFont:[UIFont fontWithName:@"System" size:9]];
                noLbl.text = @"#";
                [noLbl setTextColor:[UIColor whiteColor]];
                [headerCell addSubview:noLbl];
            });
            
            headerCell.handiCpLblView.hidden = YES;
            
        }
        
        else if (indexPath.row >1 && indexPath.row <= numberOfLeftColumns)
        {
            headerCell.lblHeading.text = @"HCP";
            //headerCell.dotView.hidden = NO;
            headerCell.greenDotImgView.hidden = NO;
            //calculate index for tee-box
            int index = (int)numberOfLeftColumns- (int)indexPath.row;
            ScoreCardHole *hole = [scoreCard_.holesArray objectAtIndex:index];
            ScoreCardTeeBox *teeBox = [hole.teeBoxArray objectAtIndex:index];
            headerCell.handiCpLbl.hidden = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
            
                CGRect frame = headerCell.handiCpLblView.frame;
                headerCell.handiCpLblView.frame = CGRectMake(frame.origin.x+5, frame.origin.y, frame.size.width-15, frame.size.height);
                [headerCell.handiCpLblView setBackgroundColor:[self colorWithHexString:teeBox.color alpha:1]];
                
            });
            
            
        }
        else if(indexPath.row > numberOfLeftColumns){
            int userIndex = (int)indexPath.row - (int)numberOfLeftColumns - 1;
            if (userIndex < scoreCard_.users.count) {
                ScoreCardUser *user = [scoreCard_.users objectAtIndex:userIndex];
                headerCell.lblHeading.text = user.firstName;
                headerCell.handiCpLbl.text = [NSString stringWithFormat:@"%d HCP",[user.handiCap intValue]];
                //set the color
                headerCell.handiCpLblView.backgroundColor = [self colorWithHexString:user.scoreCardTeeBox.color alpha:1];
                
            }
            
        }
        else
        {
            headerCell.handiCpLblView.hidden = YES;
        }
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rightParentCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UICollectionViewCell alloc]init];
        }
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rightColorImage"]];
        ScoreBoardBodyCell *bodyCell = (ScoreBoardBodyCell *)cell;
       bodyCell.containerImgView.hidden = YES;
        bodyCell.greeDotImgView.hidden = YES;
        if (indexPath.row > numberOfLeftColumns) {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftColorImage"]];
        }
            
        if (indexPath.section == 10) {
            
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rightColorImage"]];
            ScoreBoardBodyCell *bodyCell = (ScoreBoardBodyCell *)cell;
            if (indexPath.row == 0) {
                
                bodyCell.contentLbl.text = @"OUT";
            }
            else if (indexPath.row == 1)
            {
                bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",parTotal_];
            }
            else if (indexPath.row > numberOfLeftColumns)
            {
                ScoreBoardBodyCell *bodyCell = (ScoreBoardBodyCell *)cell;
                int index = (int)indexPath.row - (int)numberOfLeftColumns - 1;
                ScoreCardUser *scoreCardUser = [scoreCard_.users objectAtIndex:index];
                bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",scoreCardUser.grossFirst];
                
            }
            else
            {
                bodyCell.contentLbl.text = @"";
            }
            
        }
        else if (indexPath.section == 20)
        {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rightColorImage"]];
            ScoreBoardBodyCell *bodyCell = (ScoreBoardBodyCell *)cell;
            if (indexPath.row == 0) {
                
                bodyCell.contentLbl.text = @"IN";
            }
            else if (indexPath.row == 1)
            {
                bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",parTotal2_];
            }
            else if (indexPath.row > numberOfLeftColumns)
            {
                ScoreBoardBodyCell *bodyCell = (ScoreBoardBodyCell *)cell;
                int index = (int)indexPath.row - (int)numberOfLeftColumns - 1;
                ScoreCardUser *scoreCardUser = [scoreCard_.users objectAtIndex:index];
                bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",scoreCardUser.grossLast];
            }
            else
            {
                bodyCell.contentLbl.text = @"";
            }
            
        }
        else if (indexPath.section == 21)
        {
            if (indexPath.row == 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //bodyCell.contentLbl.font = [UIFont fontWithName:@"Arial" size:8];
                    bodyCell.contentLbl.text = @"TOTAL";
                    
                });
                
            }
            else if (indexPath.row == 1)
            {
                bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",parTotal_+parTotal2_];
            }
            else if (indexPath.row > numberOfLeftColumns)
            {
                
                ScoreBoardBodyCell *bodyCell = (ScoreBoardBodyCell *)cell;
                int index = (int)indexPath.row - (int)numberOfLeftColumns - 1;
                ScoreCardUser *scoreCardUser = [scoreCard_.users objectAtIndex:index];
                bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",scoreCardUser.grossFirst+scoreCardUser.grossLast];
                
            }
            else
            {
                
                bodyCell.contentLbl.text = @"";
            }
            if (indexPath.row == 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    bodyCell.contentLbl.font = [UIFont fontWithName:@"Arial" size:10];
                    bodyCell.contentLbl.text = @"TOTAL";
                    
                });
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    bodyCell.contentLbl.font = [UIFont fontWithName:@"Arial" size:12];
                    
                });
            }
        }
        else if (indexPath.section == 22)
        {
            if (indexPath.row == 0) {
                bodyCell.contentLbl.text = @"NET";
            }
            else
            {
                if (indexPath.row > numberOfLeftColumns) {
                    
                    int index = (int)indexPath.row - (int)numberOfLeftColumns - 1;
                    //ScoreCardHole *hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];
                    ScoreCardUser *cardUser = [scoreCard_.users objectAtIndex:index];
                    if (cardUser) {
                        int total = cardUser.grossFirst+cardUser.grossLast;
                        int net = total-[cardUser.handiCap intValue];
                        bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",net];
                    }
                    
                    //ScoreCardUserScore *scoreUser = [hole.scoreUsers objectAtIndex:index];
                    
                    //
                }
                else
                {
                    bodyCell.contentLbl.text = @"";
                }
                
            }
            
        }
        else
        {
            
            if (indexPath.row == 0) {
                
                ScoreCardHole *hole = nil;
                if (indexPath.section >10 ) {

                    if (indexPath.section > 18)
                    {
                        hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-2];
                    }
                    else
                    {
                        hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-2];
                    }
                    
                    
                }
                else
                {
                    if (indexPath.section < scoreCard_.holeCount) {
                        hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];
                    }
                    
                }
                
                if (hole) {
                    
                    bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",[hole.holeNumber intValue]];
                }
                
            }
            else if (indexPath.row == 1)
            {
                ScoreCardHole *hole = nil;
                
                if (indexPath.section >10 ) {
                    
                    if (indexPath.section > 18)
                    {
                        hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-2];
                    }
                    else
                    {
                        hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-2];
                    }
                    
                    
                }
                else
                {
                    if (indexPath.section < scoreCard_.holeCount) {
                        hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];
                    }
                    
                }
                
                if (hole) {
                    
                    bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",[hole.parValue intValue]];
                }
            }
            else if (indexPath.row > numberOfLeftColumns && indexPath.section < scoreCard_.holeCount)
            {
                int index = (int)indexPath.row - (int)numberOfLeftColumns - 1;
                ScoreCardHole *hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];
                ScoreCardUserScore *scoreUser = [hole.scoreUsers objectAtIndex:index];
                if ([scoreUser.shape isEqualToString:@"circle"]) {
                    
                    bodyCell.containerImgView.hidden = NO;
                    [bodyCell.containerImgView setImage:[UIImage imageNamed:@"equal_par"]];
                    bodyCell.greeDotImgView.hidden = NO;
                }
                else
                {
                    bodyCell.containerImgView.hidden = NO;
                    [bodyCell.containerImgView setImage:[UIImage imageNamed:@"above_par"]];
                }
                bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",[scoreUser.score intValue]];
            }
            else
            {
                ScoreCardHole *hole = nil;
                
                if (indexPath.section < scoreCard_.holeCount) {
                    hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];
                }
                if (hole) {
                    
                    int index = (int)indexPath.row - 2;
                    if (index < hole.teeBoxArray.count) {
                        ScoreCardTeeBox *teeBox = [hole.teeBoxArray objectAtIndex:index];
                        bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",[teeBox.handiCap intValue]];
                    }
                    
                }

            }
        }
        
    }
    
    
    
    
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Clicked");
}
- (UIColor *)colorWithHexString:(NSString *)hexColorString alpha:(CGFloat)alpha {
    
    unsigned colorValue = 0;
    
    NSScanner *valueScanner = [NSScanner scannerWithString:hexColorString];
    
    if ([hexColorString rangeOfString:@"#"].location != NSNotFound) [valueScanner setScanLocation:1];
    
    [valueScanner scanHexInt:&colorValue];
    
    return [UIColor colorWithRed:((colorValue & 0xFF0000) >> 16)/255.0 green:((colorValue & 0xFF00) >> 8)/255.0 blue:((colorValue & 0xFF) >> 0)/255.0 alpha:alpha];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
