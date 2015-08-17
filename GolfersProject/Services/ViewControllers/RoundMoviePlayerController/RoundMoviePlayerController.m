//
//  RoundMoviePlayerController.m
//  GolfersProject
//
//  Created by Waqas Naseem on 8/10/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "RoundMoviePlayerController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
@import MediaPlayer;
@interface RoundMoviePlayerController ()
{
    MPMoviePlayerController *moviePlayer_;
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation RoundMoviePlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //@"http://45.56.104.68/system/attachments/contents/000/000/057/original/email_address.mp4?1436959273
    self.navigationItem.title = @"FLYOVER VIDEO";
    // Right bar button
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(popVideoController)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.frame = CGRectMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5, 50, 21);
    [activityIndicator setTintColor:[UIColor whiteColor]];
    [activityIndicator startAnimating];
    [activityIndicator setHidesWhenStopped:YES];
    [self.view addSubview:activityIndicator];
    
    
    moviePlayer_ = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.moviePath]];
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

- (void)viewDidAppear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    
}

- (void)moviePlayerLoadStateChanged:(NSNotification *)notif
{
    NSLog(@"loadState: %lu", (unsigned long)moviePlayer_.loadState);
    if (moviePlayer_.loadState & MPMovieLoadStateStalled) {
        [activityIndicator startAnimating];
        [moviePlayer_ pause];
    } else
        if (moviePlayer_.loadState & MPMovieLoadStatePlaythroughOK) {
        [activityIndicator stopAnimating];
        [moviePlayer_ play];
        
    }
}

- (void)moviePlayerPlaybackFinished:(NSNotification *)notif
{
    [moviePlayer_.view removeFromSuperview];
    [activityIndicator stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)popVideoController
{
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.appDelegateNavController popViewControllerAnimated:YES];
}


@end
