//
//  MYThumbnail.m
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/29.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MYThumbnail.h"

@implementation MYThumbnail

+ (instancetype)thumbnailWithImage:(UIImage *)image time:(CMTime)time {
    return [[self alloc] initWithImage:image time:time];
}

- (instancetype)initWithImage:(UIImage *)image time:(CMTime)time
{
    self = [super init];
    if (self) {
        _image = image;
        _time  = time;
    }
    return self;
}

@end
