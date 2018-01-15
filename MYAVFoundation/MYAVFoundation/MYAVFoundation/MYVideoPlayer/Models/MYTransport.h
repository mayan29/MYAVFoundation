
//
//  MYTransport.h
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/27.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@protocol MYTransportDelegate <NSObject>

- (void)play;
- (void)pause;
- (void)stop;

- (void)scrubbingDidStart;
- (void)scrubbedToTime:(NSTimeInterval)time;
- (void)scrubbingDidEnd;

- (void)jumpedToTime:(NSTimeInterval)time;

@optional
- (void)subtitleSelected:(NSString *)subtitle;

@end


// MYTransport = MYPlayerOverlayView，这里的方法都是 MYPlayerOverlayView 调用
@protocol MYTransport <NSObject>

@property (weak, nonatomic) id <MYTransportDelegate> delegate;  // delegate = MYPlayerController

- (void)setTitle:(NSString *)title;
- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;
- (void)playbackComplete;
- (void)setSubtitles:(NSArray *)subtitles;
- (void)setStillsImages:(NSArray *)images;

@end
