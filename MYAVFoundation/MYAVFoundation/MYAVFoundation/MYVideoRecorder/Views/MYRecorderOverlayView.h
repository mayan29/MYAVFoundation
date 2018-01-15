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

- (void)dismissViewControllerClick;  // 点击按钮：退出拍照
- (void)switchCameraClick;           // 点击按钮：切换摄像头

- (void)takePhotoClick;         // 点击按钮：拍照
- (void)cancelPhotoClick;       // 点击按钮：取消拍照
- (void)selectedPhotoClick;     // 点击按钮：选定照片

- (void)startShootingClick;     // 点击按钮：开始视频录制
- (void)endShootingClick;       // 点击按钮：结束视频录制
- (void)cancelShootingClick;    // 点击按钮：取消视频录制
- (void)makeSureShootingClick;  // 点击按钮：选定所录制的视频

@end


@interface MYRecorderOverlayView : UIView

@property (nonatomic, weak) id<MYRecorderOverlayViewDelegate> delegate;
@property (nonatomic, assign) ShootType shootType;  // 录像还是拍照

- (void)hiddenMassege;  // 隐藏提示语

@end
