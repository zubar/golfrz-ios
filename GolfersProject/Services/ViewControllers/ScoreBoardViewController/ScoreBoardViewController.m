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
#import "CourseServices.h"
#import "Course.h"
#import "AppDelegate.h"
#import "ClubHouseContainerVC.h"
#import "UserServices.h"
#import "GameSettings.h"
#import "PastScoreCardsViewController.h"
#import "GameType.h"
#import "AddPlayersViewController.h"


@interface ScoreBoardViewController (){
    
    NSUInteger numberOfLeftColumns;
    ScoreCard *scoreCard_;
    GameType *gameType_;
    int parTotal_;
    int parTotal2_;
}


@end

@implementation ScoreBoardViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.previousDate == nil){
   
        UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SAVE" style:UIBarButtonItemStylePlain target:self action:@selector(saveScorecardInHistory)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }

    
    self.navigationItem.title = @"SCORECARD";
    
    [ScoreBoardManager sharedScoreBoardManager].numberOfSections = 0;
    [ScoreBoardManager sharedScoreBoardManager].numberOfItems = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [ScoreBoardManager sharedScoreBoardManager].defaultSymbolsSet = [NSMutableSet setWithObjects:@"nothing",@"green_dot",@"pentagon",@"circle",@"square", nil];
    
    
    [ScoreboardServices getScoreCardForRoundId:self.roundId subCourse:self.subCourseId
                                       success:^(bool status, id responseObject)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        scoreCard_ = [[ScoreCard alloc] initWithDictionary:responseObject];
        [ScoreBoardManager sharedScoreBoardManager].numberOfItems = (int)scoreCard_.users.count + [scoreCard_.teeBoxCount intValue]+2;
        
        if(scoreCard_.holeCount >=18){
        if ([scoreCard_.gameType isEqualToString:@"skin"]) {
            [ScoreBoardManager sharedScoreBoardManager].numberOfSections = (int)scoreCard_.holeCount+6;
        }else{
            [ScoreBoardManager sharedScoreBoardManager].numberOfSections = (int)scoreCard_.holeCount+5;
        }
        }else{
            if ([scoreCard_.gameType isEqualToString:@"skin"]) {
                [ScoreBoardManager sharedScoreBoardManager].numberOfSections = (int)scoreCard_.holeCount+5;
            }else{
                [ScoreBoardManager sharedScoreBoardManager].numberOfSections = (int)scoreCard_.holeCount+4;
            }
        }
        [ScoreBoardManager sharedScoreBoardManager].scoreCard = scoreCard_;
        [self calculateParTotal];
        
        numberOfLeftColumns = [scoreCard_.teeBoxCount intValue]+2;
        self.lblNoOfHoles.text = [NSString stringWithFormat:@"%@",  @(scoreCard_.holeCount)];
        gameType_ = [[GameSettings sharedSettings] gameType];
        NSString *currentGameType = gameType_.name;
        if (currentGameType == nil)
        {
            self.lblGameType.text = self.previousGameType;
        }else{
            self.lblGameType.text = currentGameType;
        }
        if (self.previousDate == nil) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"dd-MMM-yyyy";
            NSString *currentDate = [formatter stringFromDate:[NSDate date]];
            self.lblDateOfRound.text = currentDate;
        }else{
            self.lblDateOfRound.text = self.previousDate;
        }
        [_rightCollectionView reloadData];
    }
    failure:^(bool status, NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
-(void)calculateParTotal
{
    parTotal_ = 0;
    parTotal2_ = 0;
    //For first Nine holes
    if (scoreCard_.holeCount <= 9) {
        for (int i = 0; i<9; i++) {
            ScoreCardHole *scoreCardHole = [scoreCard_.holesArray objectAtIndex:i];
            NSNumber *number = scoreCardHole.parValue;
            parTotal_ += [number intValue];
        }
    }
    
    if(scoreCard_.holeCount >= 18){
        for (int i = 9; i<18; i++) {
            ScoreCardHole *scoreCardHole = [scoreCard_.holesArray objectAtIndex:i];
            NSNumber *number = scoreCardHole.parValue;
            parTotal2_ += [number intValue];
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
        scoreCard_ = nil;
        [ScoreBoardManager sharedScoreBoardManager].scoreCard = nil;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [ScoreBoardManager sharedScoreBoardManager].numberOfItems;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [ScoreBoardManager sharedScoreBoardManager].numberOfSections;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Zee
    int indexofTotalRow = 0;
    if (scoreCard_.holeCount == 9 )
    {
        indexofTotalRow = (int)scoreCard_.holeCount + 2;
    } else {
        indexofTotalRow = (int)scoreCard_.holeCount + 3;
    }
    
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
        else if (indexPath.row >1 && indexPath.row < numberOfLeftColumns)
        {
            headerCell.lblHeading.text = @"HCP";
            //headerCell.dotView.hidden = NO;
            headerCell.greenDotImgView.hidden = NO;
            //calculate index for tee-box
            int index = (int)indexPath.section;
            int teeBoxIndex = (int)indexPath.row-2;
            
            ScoreCardHole *hole = [scoreCard_.holesArray objectAtIndex:index];
            if (teeBoxIndex >= hole.teeBoxArray.count) {
                teeBoxIndex = (int)hole.teeBoxArray.count - 1;
            }
            ScoreCardTeeBox *teeBox = [hole.teeBoxArray objectAtIndex:teeBoxIndex];
            headerCell.handiCpLbl.hidden = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
            
                CGRect frame = headerCell.handiCpLblView.frame;
                headerCell.handiCpLblView.frame = CGRectMake(frame.origin.x+5, frame.origin.y, frame.size.width-15, frame.size.height);
                [headerCell.handiCpLblView setBackgroundColor:[self colorWithHexString:teeBox.color alpha:1]];
                
            });
            
            
        }
        else if(indexPath.row >= numberOfLeftColumns){
            int userIndex = (int)indexPath.row - (int)numberOfLeftColumns;
            if (userIndex < 0) {
                userIndex = 0;
            }
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
        if (indexPath.row >= numberOfLeftColumns) {
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
            else if (indexPath.row >= numberOfLeftColumns)
            {
                ScoreBoardBodyCell *bodyCell = (ScoreBoardBodyCell *)cell;
                int index = (int)indexPath.row - (int)numberOfLeftColumns;
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
            else if (indexPath.row >= numberOfLeftColumns)
            {
                ScoreBoardBodyCell *bodyCell = (ScoreBoardBodyCell *)cell;
                int index = (int)indexPath.row - (int)numberOfLeftColumns;
                ScoreCardUser *scoreCardUser = [scoreCard_.users objectAtIndex:index];
                bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",scoreCardUser.grossLast];
            }
            else
            {
                bodyCell.contentLbl.text = @"";
            }
            
        }
        //Zee
        //else if (indexPath.section == 21)
        else if (indexPath.section == indexofTotalRow)
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
            else if (indexPath.row >= numberOfLeftColumns)
            {
                
                ScoreBoardBodyCell *bodyCell = (ScoreBoardBodyCell *)cell;
                //int index = (int)indexPath.row - (int)numberOfLeftColumns - 1;
                int index = (int)indexPath.row - (int)numberOfLeftColumns;
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
       // else if (indexPath.section == 22)
        // Zee
        else if (indexPath.section == indexofTotalRow +1)
        {
            if (indexPath.row == 0) {
                bodyCell.contentLbl.text = @"NET";
            }
            else
            {
                if (indexPath.row >= numberOfLeftColumns) {
                    
                    int index = (int)indexPath.row - (int)numberOfLeftColumns;
                
                    ScoreCardUser *cardUser = [scoreCard_.users objectAtIndex:index];
                    if (cardUser) {
                        int total = cardUser.grossFirst+cardUser.grossLast;
                        int net = total-[cardUser.handiCap intValue];
                        bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",net];
                    }
                    
                    //
                }
                else
                {
                    bodyCell.contentLbl.text = @"";
                }
                
            }
            
        }
        //else if ([scoreCard_.gameType isEqualToString:@"skin"] && indexPath.section == 23)
        else if ([scoreCard_.gameType isEqualToString:@"skin"] && indexPath.section == indexofTotalRow +2)
        {
            if (indexPath.row == 0) {
                bodyCell.contentLbl.text = @"SKINS";
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    bodyCell.contentLbl.font = [UIFont fontWithName:@"Arial" size:10];
                    
                });
            }
            else if (indexPath.row == 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    bodyCell.contentLbl.font = [UIFont fontWithName:@"Arial" size:12];
                    
                });
                bodyCell.contentLbl.text = @"";
                bodyCell.containerImgView.hidden = NO;

                dispatch_async(dispatch_get_main_queue(), ^{
                    [bodyCell.containerImgView setImage:[UIImage imageNamed:@"skin_symbol"]];
                });
            }
            else
            {
                bodyCell.containerImgView.hidden = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    bodyCell.contentLbl.font = [UIFont fontWithName:@"Arial" size:12];
                    
                });
                bodyCell.contentLbl.text = @"";
                
                if (indexPath.row >= numberOfLeftColumns) {
                    
                    NSLog(@"indexpath :%d",(int)indexPath.row);
                    int index = (int)indexPath.row - (int)numberOfLeftColumns;
                    ScoreCardUser *cardUser = [scoreCard_.users objectAtIndex:index];
                    if (cardUser) {
                        
                        bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",[cardUser.skinCount intValue]];
                    }
                    
                }
                else
                {
                    bodyCell.contentLbl.text = @"";
                }
            }
        }
        else // For GameType Stroke
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
                        if(indexPath.section -2 < [scoreCard_.holesArray count])
                        hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-2];
                    }
                    
                }
                else
                {
                    if (indexPath.section < scoreCard_.holeCount) {
                        hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];
                    }else
                        hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];

                }
                if (hole) {
                    bodyCell.contentLbl.text = [self mappingFunctionHoleNumber:hole.holeNumber];
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
                        if(indexPath.section - 2 < [scoreCard_.holesArray count])
                        hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-2];
                    }
                }
                else
                {
                    if (indexPath.section < scoreCard_.holeCount) {
                        hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];
                    }else{
                        hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];
                    }
                }
                if (hole) {
                    bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",[hole.parValue intValue]];
                }
            }
            else if (indexPath.row >= numberOfLeftColumns && indexPath.section < scoreCard_.holeCount+2)
            {
                bodyCell.contentLbl.text = @"";
                
                int index = (int)indexPath.row - (int)numberOfLeftColumns;
                ScoreCardHole *hole = nil;
                if (indexPath.section > 10) {
                    hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-2];
                }
                else
                {
                    hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-1];
                }
                ScoreCardUserScore *scoreUser = [hole.scoreUsers objectAtIndex:index];
                if ([scoreUser.score intValue] > 0) {
                    
                    for (NSString *key in scoreUser.symbolsArray) {
                        
                        NSString *compareString = [key copy];
                        compareString = [[compareString lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
                       
                        if ([scoreCard_.gameType isEqualToString:@"skin"]) {
                            if ([compareString isEqualToString:@"pentagon"]) {
                                bodyCell.containerImgView.hidden = NO;
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [bodyCell.containerImgView setImage:[UIImage imageNamed:@"skin_symbol"]];
                                });
                            }
                            if ([compareString isEqualToString:@"green_dot"]) {
                                bodyCell.greeDotImgView.hidden = NO;
                            }
                        }else{
                        // If game type is Stroke
                        if ([compareString isEqualToString:@"green_dot"]) {
                            
                            bodyCell.greeDotImgView.hidden = NO;
                        }
                        else if ([compareString isEqualToString:@"nothing"]) {
                            bodyCell.containerImgView.hidden = YES;
                        }
                        else if ([compareString isEqualToString:@"pentagon"]) {
                            bodyCell.containerImgView.hidden = NO;
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [bodyCell.containerImgView setImage:[UIImage imageNamed:@"skin_symbol"]];
                            });
                            
                        }
                        else if ([compareString isEqualToString:@"circle"]) {
                            bodyCell.containerImgView.hidden = NO;
                            [bodyCell.containerImgView setImage:[UIImage imageNamed:@"equal_par"]];
                            
                        }
                        else if ([compareString isEqualToString:@"square"]) {
                            bodyCell.containerImgView.hidden = NO;
                            [bodyCell.containerImgView setImage:[UIImage imageNamed:@"above_par"]];
                            
                        }
                    }
                }
                    bodyCell.contentLbl.text = [NSString stringWithFormat:@"%d",[scoreUser.score intValue]];
                }
                else
                {
                    bodyCell.contentLbl.text = @"-";
                    bodyCell.containerImgView.hidden = YES;
                    bodyCell.greeDotImgView.hidden = YES;
                }
                
            }
            else
            {
                ScoreCardHole *hole = nil;
                if (indexPath.section > 10) {
                    if(indexPath.section -2 < [scoreCard_.holesArray count])
                    hole = [scoreCard_.holesArray objectAtIndex:indexPath.section-2];
                }
                else
                {
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

-(NSString *)mappingFunctionHoleNumber:(NSNumber *)holeNum
{
    
    if([[scoreCard_ holesArray] count] >10){
        return [NSString stringWithFormat:@"%@", holeNum];
    }else
        if([[scoreCard_ holesArray] count] <=9 && [holeNum integerValue] > 9){
            return [NSString stringWithFormat:@"%ld", [holeNum integerValue] - 9];
        }
    return [NSString stringWithFormat:@"%@", holeNum];
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

#pragma mark - Navigation
-(void)baseBackBtnTap{

    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    
    for (UIViewController * controller  in [delegate.appDelegateNavController viewControllers]) {
        if ([controller isKindOfClass:[PastScoreCardsViewController class]]) {
            [delegate.appDelegateNavController popToViewController:controller animated:YES];
        }else
            if ([controller isKindOfClass:[AddPlayersViewController class]]) {
                [delegate.appDelegateNavController popToViewController:controller animated:NO];
            }
    }
    
}
- (void)saveScorecardInHistory{
    // This is the shit- WEB TEAM has forced us to do.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * currUserId = [NSString stringWithFormat:@"%@", [UserServices currentUserId]];
    
    for (ScoreCardUser * user in [scoreCard_ users]) {
        if ([[[user userId] stringValue] isEqualToString:currUserId]) {
            int totalGross = [user grossFirst] + [user grossLast];
            int totalNet = totalGross - [[user handiCap] intValue];
            
            // Check if round id is present,
            if([self roundId] != nil){
                [ScoreboardServices saveScoreBoardForRoundId:[self roundId] grossScore:[NSNumber numberWithInt:totalGross] netScore:[NSNumber numberWithInt:totalNet] skinCount:[user skinCount]
                                                     success:^(bool status, id response)
                 {
                     //Do nothing.
                     if(status)
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                         [[[UIAlertView alloc] initWithTitle:@"ScoreCard saved." message:@"This scorecard is saved in your history of past scorecards." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                     
                 } failure:^(bool status, GolfrzError *error) {
                     if(!status)
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                         [[[UIAlertView alloc] initWithTitle:@"ScoreCard Can not be Saved!" message:@"This scorecard can not be saved in your history of past scorecards." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                 }];
            }
            
        }
    }
}

@end
