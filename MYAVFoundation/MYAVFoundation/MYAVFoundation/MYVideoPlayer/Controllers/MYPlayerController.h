//
//  MYPlayerController.h
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/27.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYPlayerController : NSObject

- (instancetype)initWithURL:(NSURL *)assetURL;

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, assign) BOOL isLoopPlayback;

@end
