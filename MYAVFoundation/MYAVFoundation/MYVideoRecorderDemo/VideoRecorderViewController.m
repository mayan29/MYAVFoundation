//
//  VideoRecorderViewController.m
//  MYAVFoundation
//
//  Created by mayan on 2018/1/16.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "VideoRecorderViewController.h"
#import "MYRecorderViewController.h"
#import "MYPlayerController.h"
#import "MYPlayerView.h"

@interface VideoRecorderViewController () <MYRecorderViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) MYPlayerView *playerView;
@property (nonatomic, strong) MYPlayerController *playerController;

@end

@implementation VideoRecorderViewController

- (IBAction)buttonClick:(UIButton *)sender {
    
    self.imageView.hidden = YES;
    [self.playerView removeFromSuperview];
    
    MYRecorderViewController *vc = [[MYRecorderViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - MYRecorderViewControllerDelegate

- (void)captureStillImage:(UIImage *)image {
    
    self.imageView.hidden = NO;
    self.imageView.image = image;
}

- (void)captureVideoURL:(NSURL *)url {
    
    self.playerView.hidden = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.playerController = [[MYPlayerController alloc] initWithURL:url];
        self.playerController.isLoopPlayback = YES;
        
        self.playerView = (MYPlayerView *)self.playerController.view;
        self.playerView.overlayViewHidden = YES;
        self.playerView.frame = self.imageView.frame;
        [self.view addSubview:self.playerView];
    });
    
    
}


@end
