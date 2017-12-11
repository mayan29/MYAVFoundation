//
//  MYMetadata.h
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/5.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MYGenre.h"

@class AVMetadataItem;
@interface MYMetadata : NSObject

@property (nonatomic, strong) UIImage  *artwork;      // 封面
@property (nonatomic, strong) NSString *title;        // 歌曲名称
@property (nonatomic, strong) NSString *artist;       // 演唱者
@property (nonatomic, strong) NSString *albumArtist;  // 主要演唱者（iTunes 特有）
@property (nonatomic, strong) NSString *album;        // 专辑名称
@property (nonatomic, strong) NSString *comments;     // 注释
@property (nonatomic, strong) NSString *track;        // 音轨号
@property (nonatomic, strong) NSString *year;         // 年份
@property (nonatomic, strong) NSString *bpm;          // 每分钟节拍数
@property (nonatomic, strong) NSString *grouping;     // 分组
@property (nonatomic, strong) NSString *composer;     // 作曲家，设计者
@property (nonatomic, strong) NSString *disc;         // 唱片
@property (nonatomic, strong) MYGenre  *genre;        // 风格

- (instancetype)initWithItems:(NSArray <AVMetadataItem *>*)items;

- (NSArray <AVMetadataItem *>*)metadataItems;


@end
