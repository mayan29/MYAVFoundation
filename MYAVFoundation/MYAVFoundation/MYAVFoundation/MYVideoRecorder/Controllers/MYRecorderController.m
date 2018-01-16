//
//  MYRecorderController.m
//  MYVideoRecorder
//
//  Created by mayan on 2018/1/11.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "MYRecorderController.h"
#import <UIKit/UIKit.h>

@interface MYRecorderController () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureSession          *session;
@property (nonatomic, strong) AVCaptureDeviceInput      *videoInput;   // 视频输入流
@property (nonatomic, strong) AVCaptureDeviceInput      *audioInput;   // 音频输入流
@property (nonatomic, strong) AVCaptureMovieFileOutput  *movieOutput;  // 视频输出流
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;  // 照片输出流

@property (nonatomic, strong) NSURL *outputURL;

@end

@implementation MYRecorderController

#pragma mark - Session

- (BOOL)setupSession:(NSError *__autoreleasing *)error {
    
    // 创建会话
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 视频捕捉设备
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 视频输入流
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    if (self.videoInput) {
        if ([self.session canAddInput:self.videoInput]) {
            [self.session addInput:self.videoInput];
        }
    } else {
        return NO;
    }
    
    // 音频捕捉设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    // 音频输入流
    self.audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:error];
    if (self.audioInput) {
        if ([self.session canAddInput:self.audioInput]) {
            [self.session addInput:self.audioInput];
        }
    } else {
        return NO;
    }
    
    // 视频输出流
    AVCaptureMovieFileOutput *movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.session canAddOutput:movieOutput]) {
        [self.session addOutput:movieOutput];
    }
    
    // 照片输出流
    AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
    if ([self.session canAddOutput:imageOutput]) {
        [self.session addOutput:imageOutput];
    }
    
    self.movieOutput = movieOutput;
    self.imageOutput = imageOutput;
    
    return YES;
}

- (void)startSession {
    if (![self.session isRunning]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.session startRunning];
        });
    }
}

- (void)stopSession {
    if ([self.session isRunning]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.session stopRunning];
        });
    }
}


#pragma mark - Switch Camera

// 判断是否可以切换摄像头
- (BOOL)canSwitchCameras {
    
    // 可用视频捕捉设备的数量
    return [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count > 1;
}

// 切换摄像头
- (BOOL)switchCameras {
    
    if (![self canSwitchCameras]) {
        return NO;
    }
    
    NSError *error;
    AVCaptureDevice *videoDevice = [self inactiveCamera];  // 创建未激活的摄像头
    
    AVCaptureDeviceInput *videoInput =
    [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    
    if (videoInput) {
        
        [self.captureSession beginConfiguration];
        
        // 移除设备输入
        [self.captureSession removeInput:self.videoInput];
        
        if ([self.captureSession canAddInput:videoInput]) {
            self.videoInput = videoInput;
        }
        [self.captureSession addInput:self.videoInput];
        
        [self.captureSession commitConfiguration];
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(recorderController:deviceConfigurationFailedWithError:)]) {
            [self.delegate recorderController:self deviceConfigurationFailedWithError:error];
        }
        return NO;
    }
    return YES;
}

// 设置摄像头方向
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

// 返回当前未激活的摄像头捕捉设备
- (AVCaptureDevice *)inactiveCamera {
    
    AVCaptureDevice *device = nil;
    
    if ([self canSwitchCameras]) {
        // 当前激活的摄像头捕捉设备
        if (self.videoInput.device.position == AVCaptureDevicePositionBack) {
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}


#pragma mark - Flash and Torch

- (BOOL)hasTorch {
    return self.videoInput.device.hasTorch;
}

- (BOOL)hasFlash {
    return self.videoInput.device.hasFlash;
}

- (AVCaptureTorchMode)torchMode {
    return self.videoInput.device.torchMode;
}

- (AVCaptureFlashMode)flashMode {
    return self.videoInput.device.flashMode;
}

- (void)setTorchMode:(AVCaptureTorchMode)torchMode {
    
    AVCaptureDevice *device = self.videoInput.device;
    
    if (device.torchMode != torchMode && [device isTorchModeSupported:torchMode]) {
        
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.torchMode = torchMode;
            [device unlockForConfiguration];
        } else {
            [self.delegate recorderController:self deviceConfigurationFailedWithError:error];
        }
    }
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    
    AVCaptureDevice *device = self.videoInput.device;
    
    if (device.flashMode != flashMode && [device isFlashModeSupported:flashMode]) {
        
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.flashMode = flashMode;
            [device unlockForConfiguration];
        } else {
            [self.delegate recorderController:self deviceConfigurationFailedWithError:error];
        }
    }
}


#pragma mark - Focus and Exposure

// 询问激活中的摄像头是否支持兴趣点对焦
- (BOOL)isSupportsTapToFocus {
    return [self.videoInput.device isFocusPointOfInterestSupported];
}

// 询问激活中的摄像头是否支持兴趣点曝光
- (BOOL)isSupportsTapToExpose {
    return [self.videoInput.device isExposurePointOfInterestSupported];
}

// 设置对焦点
- (void)focusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = self.videoInput.device;
    
    // 是否支持兴趣点对焦 && 是否支持自动对焦
    if (device.isFocusPointOfInterestSupported &&
        [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        NSError *error;
        
        // 锁定设备准备配置
        if ([device lockForConfiguration:&error]) {
            device.focusPointOfInterest = point;
            device.focusMode = AVCaptureFocusModeAutoFocus;
            [device unlockForConfiguration];
        } else {
            [self.delegate recorderController:self deviceConfigurationFailedWithError:error];
        }
    }
}

// 设置曝光点
- (void)exposeAtPoint:(CGPoint)point {
    AVCaptureDevice *device = self.videoInput.device;
    
    if (device.isExposurePointOfInterestSupported &&
        [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        
        NSError *error;
        
        // 锁定设备准备配置
        if ([device lockForConfiguration:&error]) {
            
            device.exposurePointOfInterest = point;
            device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            
            if ([device isExposureModeSupported:AVCaptureExposureModeLocked]) {
                [device addObserver:self
                         forKeyPath:@"adjustingExposure"
                            options:NSKeyValueObservingOptionNew
                            context:nil];
            }
            
            [device unlockForConfiguration];
        } else {
            [self.delegate recorderController:self deviceConfigurationFailedWithError:error];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"adjustingExposure"]) {
        
        AVCaptureDevice *device = (AVCaptureDevice *)object;
        
        if (!device.isAdjustingExposure &&
            [device isExposureModeSupported:AVCaptureExposureModeLocked]) {
            
            [object removeObserver:self
                        forKeyPath:@"adjustingExposure"
                           context:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                if ([device lockForConfiguration:&error]) {
                    device.exposureMode = AVCaptureExposureModeLocked;
                    [device unlockForConfiguration];
                } else {
                    [self.delegate recorderController:self deviceConfigurationFailedWithError:error];
                }
            });
        }
        
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

// 重置对焦和曝光模式
- (void)resetFocusAndExposureModes {
    AVCaptureDevice *device = self.videoInput.device;
    
    // 对焦兴趣点和连续自动对焦模式是否被支持
    BOOL canResetFocus = [device isFocusPointOfInterestSupported] &&
    [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus];
    
    // 曝光度可以通过相关的功能测试被重置
    BOOL canResetExposure = [device isExposurePointOfInterestSupported] &&
    [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure];
    
    // 捕捉设备的左上角为 (0,0)，右下角为 (1,1)
    CGPoint centerPoint = CGPointMake(0.5f, 0.5f);
    
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        
        if (canResetFocus) {
            device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            device.focusPointOfInterest = centerPoint;
        }
        
        if (canResetExposure) {
            device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            device.exposurePointOfInterest = centerPoint;
        }
        
        [device unlockForConfiguration];
        
    } else {
        [self.delegate recorderController:self deviceConfigurationFailedWithError:error];
    }
}


#pragma mark - Capture Still Image and Video

- (void)captureStillImage {
    AVCaptureConnection *connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (connection.isVideoOrientationSupported) {
        connection.videoOrientation = [self currentVideoOrientation];
    }
    
    // 开启防抖模式，分辨率 1280x720 以上才会执行防抖功能
    if ([self.videoInput.device.activeFormat isVideoStabilizationModeSupported:AVCaptureVideoStabilizationModeCinematic]) {
        [connection setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeCinematic];
    }
    
    // 前置摄像头翻转
    connection.videoMirrored = (self.videoInput.device.position == AVCaptureDevicePositionFront);
    
    // Capture still image
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        
        if (imageDataSampleBuffer != NULL) {
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            if (self.delegate) {
                [self.delegate recorderController:self captureStillImage:image];
            }
            
        } else {
            NSLog(@"NULL sampleBuffer: %@", [error localizedDescription]);
        }
    }];
}

- (void)startRecording {
    
    if (![self isRecording]) {
        
        AVCaptureConnection *videoConnection = [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
        
        // 如果支持，将其设置为当前视频方向
        if ([videoConnection isVideoOrientationSupported]) {
            videoConnection.videoOrientation = self.currentVideoOrientation;
        }
        
        if ([videoConnection isVideoStabilizationSupported]) {
            videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        AVCaptureDevice *device = self.videoInput.device;
        
        // 摄像头可以进行平滑对焦模式的操作，即减慢摄像头镜头对焦的速度，从而提供更加自然的视频录制效果
        if (device.isSmoothAutoFocusSupported) {
            NSError *error;
            if ([device lockForConfiguration:&error]) {
                device.smoothAutoFocusEnabled = NO;
                [device unlockForConfiguration];
            } else {
                [self.delegate recorderController:self deviceConfigurationFailedWithError:error];
            }
        }
        
        self.outputURL = [self uniqueURL];
        [self.movieOutput startRecordingToOutputFileURL:self.outputURL recordingDelegate:self];
    }
}

- (void)stopRecording {
    if ([self isRecording]) {
        [self.movieOutput stopRecording];
    }
}

- (BOOL)isRecording {
    return self.movieOutput.isRecording;
}


#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    if (error) {
        [self.delegate recorderController:self mediaCaptureFailedWithError:error];
    } else {
        if (self.delegate) {
            [self.delegate recorderController:self captureVideoURL:outputFileURL];
        }
    }
    self.outputURL = nil;
}


#pragma mark - Other

- (AVCaptureSession *)captureSession {
    return self.session;
}

- (AVCaptureVideoOrientation)currentVideoOrientation {
    
    AVCaptureVideoOrientation orientation;
    
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    
    return orientation;
}

- (NSURL *)uniqueURL {
    
    NSString *t = [NSString stringWithFormat:@"%.0f.mp4", [[NSDate date] timeIntervalSince1970] * 1000];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:t];
    
    return [NSURL fileURLWithPath:path];
}


@end
