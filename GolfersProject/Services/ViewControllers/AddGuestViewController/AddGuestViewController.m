//
//  AddGuestViewController.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 7/13/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "AddGuestViewController.h"
#import "SharedManager.h"
#import "Hole.h"
#import "RoundDataServices.h"
#import "GameSettings.h"
#import "SubCourse.h"
#import "Teebox.h"
#import "CourseServices.h"
#import "RoundDataServices.h"
#import "MBProgressHUD.h"
#import "ValidationUtility.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "AddPlayersViewController.h"

@interface AddGuestViewController ()

@property (strong, nonatomic) NSMutableArray *teeBoxesArray;

@property (nonatomic, strong) PopOverView *popOverView;
@property (nonatomic, strong) Teebox *selectedTeeBox;

@end

@implementation AddGuestViewController

#pragma mark - view methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SharedManager * manager = [SharedManager sharedInstance];
    [self.imgViewBackground setImage:[manager backgroundImage]];
    [[self navigationItem] setTitle:@"ADD GUEST"];
    
    // Init pop over view.
    self.popOverView = [[PopOverView alloc] init];
    self.popOverView.delegate = self;

    self.selectedTeeBox = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark popOverView delegate

- (void)popOverView:(PopOverView *)popOverView indexPathForSelectedRow:(NSIndexPath *)indexPath string:(NSString *)string {
    id item = self.teeBoxesArray[indexPath.row];
    NSLog(@"%@, selectedItem-id: %@", [item name], [item itemId]);
    [self.btnTeeBox setTitle:string forState:UIControlStateNormal];
    self.selectedTeeBox = (Teebox *)item;
    [self.popOverView dismissPopOverViewAnimated:YES];
}

#pragma mark popOverView methods

- (void)presentPopOverViewPointedAtButton:(UIView *)sender {
    self.popOverView.stringDataSource = [self.teeBoxesArray valueForKeyPath:@"self.name"];
    CGPoint point = [sender convertPoint:sender.bounds.origin toView:self.view];
    CGFloat bottomPadding = 12;
    
    [self.popOverView setMinX:CGRectGetMinX(self.addGuestSettingsView.frame) maxY:point.y - bottomPadding width:CGRectGetWidth(self.addGuestSettingsView.frame) animated:YES];
    [self.popOverView showPopOverViewAnimated:YES inView:self.view];
}

#pragma mark UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.txtGuestFirstName) {
        [self.txtGuestLastName becomeFirstResponder];
    }
    if (textField == self.txtGuestLastName) {
        [self.txtGuestEmail becomeFirstResponder];
    }
    if (textField == self.txtGuestEmail) {
        [self.txtGuestHandicap becomeFirstResponder];
    }
    return YES;
}

#pragma mark - action methods

- (IBAction)btnSelectTeeBoxTapped:(UIButton *)sender {
    GameSettings *gameSettings = [GameSettings sharedSettings];
    
    self.teeBoxesArray = [[((Hole *)[gameSettings.subCourse holes][0]) teeboxes] mutableCopy];
    [self presentPopOverViewPointedAtButton:sender];
}

- (IBAction)btnAddGuestTapped:(UIButton *)sender {
    
    if ([ValidationUtility isBlankLine:self.txtGuestFirstName.text]) {
        [[[UIAlertView alloc] initWithTitle:kError message:kFirstNameEmptyErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil, nil] show];
        return;
    }
    if ([ValidationUtility isBlankLine:self.txtGuestLastName.text]) {
        [[[UIAlertView alloc] initWithTitle:kError message:kLastNameEmptyErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil, nil] show];
        return;
    }
    if (![ValidationUtility isEmail:self.txtGuestEmail.text]) {
        [[[UIAlertView alloc] initWithTitle:kError message:kEmailErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil, nil] show];
        return;
    }
    if (![ValidationUtility isOnlyNumbers:self.txtGuestHandicap.text]) {
        [[[UIAlertView alloc] initWithTitle:kError message:kNumberHandicapErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil, nil] show];
        return;
    }
    if (self.selectedTeeBox == nil) {
        [[[UIAlertView alloc] initWithTitle:kError message:kNumberHandicapErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil, nil] show];
        return;
    }
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RoundDataServices addGuestWithEmail:[self.txtGuestEmail text] firstName:[self.txtGuestFirstName text] lastName:[self.txtGuestLastName text] handicap:[numberFormatter numberFromString:[self.txtGuestHandicap text]] teeBoxId:self.selectedTeeBox.itemId success:^(bool status, NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:kSuccess message:kAddGuestSuccessMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil, nil] show];
        [self popToAddPlayerVC];
        
    } failure:^(bool status, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:kError message:kAddGuestErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil, nil] show];
    }];
}

-(void)popToAddPlayerVC{
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (UIViewController * controller  in [appDelegate.appDelegateNavController viewControllers]) {
        if([controller isKindOfClass:[AddPlayersViewController class]]){
            [appDelegate.appDelegateNavController popToViewController:controller animated:YES]
            ;        }
    }
}

@end
