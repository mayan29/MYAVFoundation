//
//  MYThumbnail.h
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/29.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

@interface MYThumbnail : NSObject

+ (instancetype)thumbnailWithImage:(UIImage *)image time:(CMTime)time;

@property (nonatomic, assign, readonly) CMTime time;
@property (nonatomic, strong, readonly) UIImage *image;

@end
