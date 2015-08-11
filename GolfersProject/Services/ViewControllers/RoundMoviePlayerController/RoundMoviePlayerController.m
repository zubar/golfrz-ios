//
//  RoundMoviePlayerController.m
//  GolfersProject
//
//  Created by Waqas Naseem on 8/10/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RoundMoviePlayerController.h"
#import "AppDelegate.h"
@import MediaPlayer;
@interface RoundMoviePlayerController ()
{
    MPMoviePlayerController *moviePlayer_;
}
@end

@implementation RoundMoviePlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    moviePlayer_ = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://45.56.104.68/system/attachments/contents/000/000/057/original/email_address.mp4?1436959273"]];
    moviePlayer_.view.frame = self.view.bounds;
    [moviePlayer_ prepareToPlay];
    
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    appDel.shouldRestricOrient = YES;
    [self.view addSubview:moviePlayer_.view];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [moviePlayer_ play];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    appDel.shouldRestricOrient = NO;
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

@end
