//
//  MYPlayerViewController.m
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/27.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MYPlayerViewController.h"
#import "MYPlayerController.h"

@interface MYPlayerViewController ()

@property (nonatomic, strong) MYPlayerController *controller;

@end

@implementation MYPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.controller = [[MYPlayerController alloc] initWithURL:self.assetURL];
    
    UIView *playerView = self.controller.view;
    playerView.frame = self.view.bounds;
    [self.view addSubview:playerView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
