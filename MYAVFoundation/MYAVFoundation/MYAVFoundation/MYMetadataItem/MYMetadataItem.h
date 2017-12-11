//
//  MYMetadataItem.h
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/5.
//  Copyright © 2017年 mayan. All rights reserved.
//
//  媒体管理，封装了基础 AVAsset 实例并负责管理相关元数据的载入和解析

#import <Foundation/Foundation.h>
#import "MYMetadata.h"
#import "MYMetadataKeys.h"

@interface MYMetadataItem : NSObject

@property (nonatomic, readonly, strong) NSString   *filename;
@property (nonatomic, readonly, strong) NSString   *filetype;
@property (nonatomic, readonly, strong) MYMetadata *metadata;
@property (nonatomic, readonly, assign) BOOL        editable;  // mp3 格式不能修改

- (instancetype)initWithURL:(NSURL *)url;
- (void)prepareWithCompletionHandler:(void(^)(BOOL complete))handler;
- (void)saveWithCompletionHandler:(void(^)(BOOL complete))handler;


@end
