// *******************************************
//  File Name:      VideoPlayerVc.m       
//  Author:         MrBai
//  Created Date:   2021/12/17 11:41 AM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "VideoPlayerVc.h"
#import "BQPlayerView.h"
#import "BQVideoView.h"

@interface VideoPlayerVc ()
@property (nonatomic, strong) BQVideoView * videoPlayer;
@end

@implementation VideoPlayerVc


#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

#pragma mark - *** Delegate

#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    NSString * urlStr = [[NSBundle mainBundle] pathForResource:@"test" ofType:@".mp4"];
    self.videoPlayer = [BQVideoView playerWithFrame:CGRectMake(0, self.navbarBottom, self.view.width, self.view.width * 9 / 16) url:urlStr];
    self.videoPlayer.title = @"暴力云与送子鹤";
    [self.view addSubview:self.videoPlayer];
}

#pragma mark - *** Set

#pragma mark - *** Get
    

@end
