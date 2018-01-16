//
//  MYPlayerController.m
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/27.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MYPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "MYPlayerView.h"
#import "MYThumbnail.h"

#define STATUS_KEYPATH @"status"


@interface MYPlayerController () <MYTransportDelegate>

@property (nonatomic, strong) AVAsset      *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer     *player;
@property (nonatomic, strong) MYPlayerView *playerView;

@property (nonatomic, strong) id timeObserver;
@property (nonatomic, strong) id itemEndObserver;
@property (nonatomic, assign) float lastPlaybackRate;

@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;

@end

@implementation MYPlayerController

#pragma mark - Init

- (instancetype)initWithURL:(NSURL *)assetURL
{
    self = [super init];
    if (self) {
        _url = assetURL;
        [self prepareToPlay:assetURL];
    }
    return self;
}

- (void)prepareToPlay:(NSURL *)assetURL {
    
    self.asset = [AVAsset assetWithURL:assetURL];
    
    NSArray *keys = @[@"tracks",
                      @"duration",
                      @"commonMetadata",
                      @"availableMediaCharacteristicsWithMediaSelectionOptions"];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset
                           automaticallyLoadedAssetKeys:keys];
    [self.playerItem addObserver:self forKeyPath:STATUS_KEYPATH options:0 context:nil];

    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    self.playerView = [[MYPlayerView alloc] initWithPlayer:self.player];
    self.playerView.transport.delegate = self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    // 监听状态改变
    if ([keyPath isEqualToString:STATUS_KEYPATH]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.playerItem removeObserver:self forKeyPath:STATUS_KEYPATH];
            
            if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                
                // Set up time observers.
                [self addPlayerItemTimeObserver];
                [self addItemEndObserverForPlayerItem];
                
                // Synchronize the time display
                [self.playerView.transport setCurrentTime:CMTimeGetSeconds(kCMTimeZero)
                                                 duration:CMTimeGetSeconds(self.playerItem.duration)];
                
                // Set the video title.
                [self.playerView.transport setTitle:[self getTitle]];
                
                [self.player play];
                
                // 字幕
                [self loadMediaOptions];
                // 可视搓擦条
                [self generateThumbnails];
            } else {
                NSAssert(self.playerItem.status != AVPlayerItemStatusFailed, @"Failed to load video");
            }
        });
    }
}

- (void)dealloc {
    
    if (self.itemEndObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.itemEndObserver
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.player.currentItem];
        self.itemEndObserver = nil;
    }
}


#pragma mark - Time Observers

// 定期监听
- (void)addPlayerItemTimeObserver {
    
    __weak typeof(self)weakSelf = self;
    
    // 使用下面方法，可以以一定的时间间隔获得通知
    self.timeObserver =
        [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.5f, NSEC_PER_SEC)
                                                  queue:dispatch_get_main_queue()
                                             usingBlock:^(CMTime time) {
                                             
        // 设置当前时间和总时长
        [weakSelf.playerView.transport setCurrentTime:CMTimeGetSeconds(time)
                                             duration:CMTimeGetSeconds(weakSelf.playerItem.duration)];
    }];
}

// 播放完毕监听
- (void)addItemEndObserverForPlayerItem {
    
    __weak typeof(self)weakSelf = self;
    
    self.itemEndObserver =
        [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                          object:self.playerItem
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                      
        [weakSelf.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [self.playerView.transport playbackComplete];
            if (self.isLoopPlayback) {
                [self play];
            }
        }];
    }];
}


#pragma mark - MYTransportDelegate

- (void)play {
    [self.player play];
}

- (void)pause {
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
}

- (void)stop {
    [self.player setRate:0.0f];
    [self.playerView.transport playbackComplete];  // 更新搓擦条的位置
}

// 获取当前播放率并暂停播放器
- (void)scrubbingDidStart {
    
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
}

// 移动滑动条触发
- (void)scrubbedToTime:(NSTimeInterval)time {
    // 如果前一个搜索请求没有完成，则避免出现搜索操作堆积情况
    [self.playerItem cancelPendingSeeks];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

// 已经完成了搓擦操作
- (void)scrubbingDidEnd {
    
    [self addPlayerItemTimeObserver];
    // 如果播放率大于 0 则表示视频已经播放过了，需要重新播放该视频
    if (self.lastPlaybackRate > 0.0f) {
        [self.player play];
    }
}

// 跳转到时间轴上的任意位置
- (void)jumpedToTime:(NSTimeInterval)time {
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

// 设置字幕
- (void)subtitleSelected:(NSString *)subtitle {
    
    AVMediaSelectionGroup *group =
        [self.asset mediaSelectionGroupForMediaCharacteristic:AVMediaCharacteristicLegible];
    
    for (AVMediaSelectionOption *option in group.options) {
        if ([option.displayName isEqualToString:subtitle]) {
            [self.playerItem selectMediaOption:option inMediaSelectionGroup:group];
            return;
        }
    }
    [self.playerItem selectMediaOption:nil inMediaSelectionGroup:group];
}


#pragma mark - Private Method

- (UIView *)view {
    return self.playerView;
}

- (NSString *)getTitle {
    
    AVKeyValueStatus status = [self.asset statusOfValueForKey:@"commonMetadata" error:nil];
    if (status == AVKeyValueStatusLoaded) {
        NSArray *items =
            [AVMetadataItem metadataItemsFromArray:self.asset.commonMetadata
                                           withKey:AVMetadataCommonKeyTitle
                                          keySpace:AVMetadataKeySpaceCommon];
        if (items.count > 0) {
            AVMetadataItem *titleItem = [items firstObject];
            return (NSString *)titleItem.value;
        }
    }
    return nil;
}

- (void)loadMediaOptions {
    
    AVMediaSelectionGroup *group = [self.asset mediaSelectionGroupForMediaCharacteristic:AVMediaCharacteristicLegible];
    if (group) {
        NSMutableArray *subtitles = [NSMutableArray array];
        for (AVMediaSelectionOption *option in group.options) {
            [subtitles addObject:option.displayName];  // 语言字幕轨道名称，比如 English、Italian、Russian
        }
        [self.playerView.transport setSubtitles:subtitles];
    } else {
        [self.playerView.transport setSubtitles:nil];
    }
}

- (void)generateThumbnails {
    
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
    
    // 默认情况下，捕捉的图片都保持原始维度。设置 maximumSize 的宽度，则会根据视频的宽高比自动设置高度值
    self.imageGenerator.maximumSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.0f);
    
    CMTime duration = self.asset.duration;
    
    // 将视频时间轴平均分为 20 个 CMTime 值
    NSMutableArray *times = [NSMutableArray array];
    CMTimeValue increment = duration.value / 20;
    CMTimeValue currentValue = 2.0 * duration.timescale;
    while (currentValue <= duration.value) {
        CMTime time = CMTimeMake(currentValue, duration.timescale);
        [times addObject:[NSValue valueWithCMTime:time]];
        currentValue += increment;
    }
    
    __block NSUInteger imageCount = times.count;
    __block NSMutableArray *images = [NSMutableArray array];
    
    AVAssetImageGeneratorCompletionHandler handler;
    
    // requestedTime : 请求的最初时间，它对应于生成图像的调用中指定的 times 数组中的值
    // imageRef      : 生成的 CGImageRef，如果在给定的时间点没有生成图片则为 NULL
    // actualTime    : 图片实际生成的时间，可能和请求时间不同。可以在生成图片前通过 AVAssetImageGenerator 实例设置 requestedTimeToleranceBefore 和 requestedTimeToleranceAfter 值来调整 requestedTime 和 actualTime 的接近程度
    // result        : AVAssetImageGeneratorResult 用来表示生成图片成功、失败、取消
    handler = ^(CMTime requestedTime,
                CGImageRef imageRef,
                CMTime actualTime,
                AVAssetImageGeneratorResult result,
                NSError *error) {
        
        if (result == AVAssetImageGeneratorSucceeded) {
            MYThumbnail *thumbnail =
                [MYThumbnail thumbnailWithImage:[UIImage imageWithCGImage:imageRef] time:actualTime];
            [images addObject:thumbnail];
        } else {
            NSAssert(error.localizedDescription, error.localizedDescription);
        }
        
        // 如果 imageCount 等于 0 这表明所有图片都处理完成
        if (--imageCount == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.playerView.transport setStillsImages:images];
            });
        }
    };
    
    // AVAssetImageGenerator 定义了两个方法实现从视频资源中检索图片，分别为：
    //
    // copyCGImageAtTime:actualTime:error:
    // 允许在指定时间点捕捉图片，适合在展示视频缩略图。
    //
    // generateCGImagesAsynchronouslyForTimes:completionHandler:
    // 允许按照第一个参数所指定的时间段生成一个图片序列，该方法具有很高的性能，只需要调用这一个方法就可以生成一组图片
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:handler];
}

@end
