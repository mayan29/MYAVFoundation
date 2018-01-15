//
//  MYPreviewView.h
//  MYVideoRecorder
//
//  Created by mayan on 2018/1/11.
//  Copyright © 2018年 mayan. All rights reserved.
//
//  视频输出预览 view

#import <UIKit/UIKit.h>

@protocol MYPreviewViewDelegate <NSObject>

- (void)tappedToFocusAtPoint:(CGPoint)point;   // 点击对焦点
- (void)tappedToExposeAtPoint:(CGPoint)point;  // 点击曝光点
- (void)tappedToResetFocusAndExposure;         // 重置对焦和曝光模式

@end


@class AVCaptureSession;
@interface MYPreviewView : UIView

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, weak) id<MYPreviewViewDelegate> delegate;

@property (nonatomic, assign) BOOL tapToFocusEnabled;
@property (nonatomic, assign) BOOL tapToExposeEnabled;

@end
