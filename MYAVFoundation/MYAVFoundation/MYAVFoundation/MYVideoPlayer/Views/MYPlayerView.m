//
//  MYPlayerView.m
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/27.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MYPlayerView.h"
#import "MYPlayerOverlayView.h"
#import <AVFoundation/AVFoundation.h>

@interface MYPlayerView ()

@property (nonatomic, strong) MYPlayerOverlayView *overlayView;

@end


@implementation MYPlayerView

/**
 重写 layerClass 类方法返回一个 AVPlayerLayer 类
 每当创建 THPlayerView 实例时，就会使用 AVPlayerLayer 作为它的支持层
 */
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (instancetype)initWithPlayer:(AVPlayer *)player
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
//        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
//                                UIViewAutoresizingFlexibleWidth;
        
        [(AVPlayerLayer *)[self layer] setPlayer:player];
        
        _overlayView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MYPlayerOverlayView class])
                                                     owner:self
                                                   options:nil].firstObject;
        [self addSubview:_overlayView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.overlayView.frame = self.bounds;
}

- (id<MYTransport>)transport {
    return self.overlayView;
}

- (void)setOverlayViewHidden:(BOOL)overlayViewHidden {
    _overlayViewHidden = overlayViewHidden;
    self.overlayView.hidden = overlayViewHidden;
}

@end
