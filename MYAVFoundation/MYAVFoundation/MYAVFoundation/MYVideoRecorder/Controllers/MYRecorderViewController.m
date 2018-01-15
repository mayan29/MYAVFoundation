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

@interface MYRecorderViewController () <MYRecorderOverlayViewDelegate, MYRecorderControllerDelegate, MYPreviewViewDelegate>

@property (nonatomic, strong) MYRecorderController *controller;
@property (nonatomic, strong) MYPreviewView *previewView;
@property (nonatomic, strong) MYRecorderOverlayView *overlayView;

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

// 退出拍照
- (void)dismissViewControllerWithOverlayView:(MYRecorderOverlayView *)overlayView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 切换摄像头
- (void)switchCameraWithOverlayView:(MYRecorderOverlayView *)overlayView {
    
    BOOL isSuccess = [self.controller switchCameras];
    
    if (isSuccess) {
        
        BOOL hidden = NO;
        if (self.overlayView.shootType == ShootType_Photo) {
            hidden = !self.controller.hasFlash;
        } else {
            hidden = !self.controller.hasTorch;
        }
//        self.overlayView.flashControlHidden = hidden;
//        self.previewView.tapToExposeEnabled = self.cameraController.cameraSupportsTapToExpose;
//        self.previewView.tapToFocusEnabled = self.cameraController.cameraSupportsTapToFocus;
//        [self.cameraController resetFocusAndExposureModes];
    }
}

// 拍照
- (void)takePhotoWithOverlayView:(MYRecorderOverlayView *)overlayView {
    
}

// 取消拍照
- (void)cancelPhotoWithOverlayView:(MYRecorderOverlayView *)overlayView {
    
}

// 选定照片
- (void)selectedPhotoWithOverlayView:(MYRecorderOverlayView *)overlayView {
    
}

// 开始视频录制
- (void)startShootingWithOverlayView:(MYRecorderOverlayView *)overlayView {
    
}

// 结束视频录制
- (void)endShootingWithOverlayView:(MYRecorderOverlayView *)overlayView {
    
}

// 取消视频录制
- (void)cancelShootingWithOverlayView:(MYRecorderOverlayView *)overlayView {
    
}

// 选定所录制的视频
- (void)makeSureShootingWithOverlayView:(MYRecorderOverlayView *)overlayView {
    
}


#pragma mark - MYRecorderControllerDelegate

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

@end
