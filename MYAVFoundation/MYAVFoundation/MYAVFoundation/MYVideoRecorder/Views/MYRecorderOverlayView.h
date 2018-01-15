//
//  MYRecorderOverlayView.h
//  MYVideoRecorder
//
//  Created by mayan on 2018/1/11.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, ShootType) {
    ShootType_Photo,
    ShootType_Video
};

@class MYRecorderOverlayView;
@protocol MYRecorderOverlayViewDelegate <NSObject>

// 退出拍照
- (void)dismissViewControllerWithOverlayView:(MYRecorderOverlayView *)overlayView;

// 切换摄像头
- (void)switchCameraWithOverlayView:(MYRecorderOverlayView *)overlayView;

// 拍照
- (void)takePhotoWithOverlayView:(MYRecorderOverlayView *)overlayView;
// 取消拍照
- (void)cancelPhotoWithOverlayView:(MYRecorderOverlayView *)overlayView;
// 选定照片
- (void)selectedPhotoWithOverlayView:(MYRecorderOverlayView *)overlayView;

// 开始视频录制
- (void)startShootingWithOverlayView:(MYRecorderOverlayView *)overlayView;
// 结束视频录制
- (void)endShootingWithOverlayView:(MYRecorderOverlayView *)overlayView;
// 取消视频录制
- (void)cancelShootingWithOverlayView:(MYRecorderOverlayView *)overlayView;
// 选定所录制的视频
- (void)makeSureShootingWithOverlayView:(MYRecorderOverlayView *)overlayView;

@end


@interface MYRecorderOverlayView : UIView

@property (nonatomic, weak) id<MYRecorderOverlayViewDelegate> delegate;
@property (nonatomic, assign) ShootType shootType;  // 录像还是拍照

- (void)hiddenMassege;  // 隐藏提示语

@end
