//
//  MYRecorderViewController.m
//  MYVideoRecorder
//
//  Created by mayan on 2018/1/11.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "MYRecorderViewController.h"
#import "MYRecorderController.h"
#import "MYPreviewView.h"
#import "MYRecorderOverlayView.h"
#import "MYPlayerController.h"
#import "MYPlayerView.h"

@interface MYRecorderViewController () <MYRecorderOverlayViewDelegate, MYRecorderControllerDelegate, MYPreviewViewDelegate>

@property (nonatomic, strong) MYRecorderController *controller;
@property (nonatomic, strong) MYPreviewView *previewView;
@property (nonatomic, strong) MYRecorderOverlayView *overlayView;

@property (nonatomic, strong) MYPlayerController *playerController;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MYPlayerView *playerView;

@end

@implementation MYRecorderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.previewView = [[MYPreviewView alloc] initWithFrame:self.view.bounds];
    self.previewView.delegate = self;
    [self.view addSubview:self.previewView];
    
    self.overlayView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MYRecorderOverlayView class]) owner:nil options:nil].firstObject;
    self.overlayView.frame = self.view.bounds;
    self.overlayView.delegate = self;
    [self.view addSubview:self.overlayView];

    self.controller = [[MYRecorderController alloc] init];
    self.controller.delegate = self;
    
    NSError *error;
    if ([self.controller setupSession:&error]) {
        [self.previewView setSession:self.controller.captureSession];
        [self.controller startSession];
    } else {
        NSAssert(!error, error.localizedDescription);
    }
    
    self.previewView.tapToFocusEnabled = self.controller.isSupportsTapToFocus;
    self.previewView.tapToExposeEnabled = self.controller.isSupportsTapToExpose;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.overlayView hiddenMassege];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - MYRecorderOverlayViewDelegate

// 点击按钮：退出拍照
- (void)dismissViewControllerClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 点击按钮：切换摄像头
- (void)switchCameraClick {
    
    if ([self.controller switchCameras]) {
        
        BOOL hidden = NO;
        if (self.overlayView.shootType == ShootType_Photo) {
            hidden = !self.controller.hasFlash;
        } else {
            hidden = !self.controller.hasTorch;
        }
        //        self.overlayView.flashControlHidden = hidden;
        self.previewView.tapToExposeEnabled = self.controller.isSupportsTapToExpose;
        self.previewView.tapToFocusEnabled = self.controller.isSupportsTapToFocus;
        [self.controller resetFocusAndExposureModes];
    }
}

// 点击按钮：拍照
- (void)takePhotoClick {
    [self.controller captureStillImage];
}

// 点击按钮：取消拍照
- (void)cancelPhotoClick {
    [self dismissStillImage];
}

// 点击按钮：选定照片
- (void)selectedPhotoClick {
    if (self.delegate) {
        [self.delegate captureStillImage:self.imageView.image];
    }
    [self dismissViewControllerClick];
}

// 点击按钮：开始视频录制
- (void)startShootingClick {
    [self.controller startRecording];
}

// 点击按钮：结束视频录制
- (void)endShootingClick {
    [self.controller stopRecording];
}

// 点击按钮：取消视频录制
- (void)cancelShootingClick {
    [self.controller stopRecording];
    [self dismissVideoPlayer];
}

// 点击按钮：选定所录制的视频
- (void)makeSureShootingClick {
    if (self.delegate) {
        [self.delegate captureVideoURL:self.playerController.url];
    }
    [self dismissViewControllerClick];
}


#pragma mark - MYRecorderControllerDelegate

- (void)recorderController:(MYRecorderController *)controller captureStillImage:(UIImage *)image {
    if (image) {
        [self showStillImage:image];
    }
}

- (void)recorderController:(MYRecorderController *)controller captureVideoURL:(NSURL *)url {
    if (url) {
        [self showVideoPlayer:url];
    }
}

- (void)recorderController:(MYRecorderController *)controller deviceConfigurationFailedWithError:(NSError *)error {
    
}

- (void)recorderController:(MYRecorderController *)controller mediaCaptureFailedWithError:(NSError *)error {
    
}

- (void)recorderController:(MYRecorderController *)controller assetLibraryWriteFailedWithError:(NSError *)error {
    
}


#pragma mark - MYPreviewViewDelegate

- (void)tappedToFocusAtPoint:(CGPoint)point {
    [self.controller focusAtPoint:point];
}

- (void)tappedToExposeAtPoint:(CGPoint)point {
    [self.controller exposeAtPoint:point];
}

- (void)tappedToResetFocusAndExposure {
    [self.controller resetFocusAndExposureModes];
}


#pragma mark - Other

- (void)showStillImage:(UIImage *)image {
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.image = image;
    [self.view insertSubview:self.imageView belowSubview:self.overlayView];
}

- (void)dismissStillImage {
    [self.imageView removeFromSuperview];
    self.imageView = nil;
}

- (void)showVideoPlayer:(NSURL *)url {
    
    self.playerController = [[MYPlayerController alloc] initWithURL:url];
    self.playerController.isLoopPlayback = YES;
    
    self.playerView = (MYPlayerView *)self.playerController.view;
    self.playerView.frame = self.view.bounds;
    self.playerView.overlayViewHidden = YES;
    [self.view insertSubview:self.playerView belowSubview:self.overlayView];
}

- (void)dismissVideoPlayer {
    [self.playerView removeFromSuperview];
    self.playerView = nil;
    self.playerController = nil;
}


@end
