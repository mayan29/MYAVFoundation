//
//  MYPlayerView.h
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/27.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYTransport.h"

@class AVPlayer;
@interface MYPlayerView : UIView

- (instancetype)initWithPlayer:(AVPlayer *)player;

@property (nonatomic, weak, readonly) id<MYTransport> transport;
@property (nonatomic, assign) BOOL overlayViewHidden;

@end
