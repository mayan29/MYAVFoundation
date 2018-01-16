//
//  MYRecorderController.h
//  MYVideoRecorder
//
//  Created by mayan on 2018/1/11.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class MYRecorderController;
@protocol MYRecorderControllerDelegate <NSObject>

- (void)recorderController:(MYRecorderController *)controller deviceConfigurationFailedWithError:(NSError *)error;
- (void)recorderController:(MYRecorderController *)controller mediaCaptureFailedWithError:(NSError *)error;
- (void)recorderController:(MYRecorderController *)controller assetLibraryWriteFailedWithError:(NSError *)error;

- (void)recorderController:(MYRecorderController *)controller captureStillImage:(UIImage *)image;
- (void)recorderController:(MYRecorderController *)controller captureVideoURL:(NSURL *)url;

@end


@interface MYRecorderController : NSObject

@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;
@property (nonatomic, weak) id<MYRecorderControllerDelegate> delegate;

// 配置和控制捕捉会话
- (BOOL)setupSession:(NSError **)error;
- (void)startSession;
- (void)stopSession;

// 切换摄像头
- (BOOL)switchCameras;
- (BOOL)canSwitchCameras;

// 手电筒 & 闪光灯
- (BOOL)hasTorch;
- (BOOL)hasFlash;
@property (nonatomic, assign) AVCaptureTorchMode torchMode;
@property (nonatomic, assign) AVCaptureFlashMode flashMode;

// 支持对焦 & 曝光
- (BOOL)isSupportsTapToFocus;
- (BOOL)isSupportsTapToExpose;
- (void)focusAtPoint:(CGPoint)point;
- (void)exposeAtPoint:(CGPoint)point;
- (void)resetFocusAndExposureModes;

// Still Image Capture
- (void)captureStillImage;

// Video Recording
- (void)startRecording;
- (void)stopRecording;
- (BOOL)isRecording;

@end
