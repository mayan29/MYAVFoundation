//
//  MYMetadataItem.m
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/5.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MYMetadataItem.h"
#import <AVFoundation/AVFoundation.h>

@interface MYMetadataItem ()

@property (nonatomic, strong) NSURL   *url;
@property (nonatomic, strong) AVAsset *asset;

@end

@implementation MYMetadataItem

#pragma mark - Init
- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url      = url;
        _asset    = [AVAsset assetWithURL:url];
        _filename = url.lastPathComponent;
        _filetype = [self fileType];
        _editable = [_filetype isEqualToString:AVFileTypeMPEGLayer3];
    }
    return self;
}


#pragma mark - Public Method
- (void)prepareWithCompletionHandler:(void (^)(BOOL))handler
{
    if (_metadata) {
        if (handler) {
            handler(YES);
            return;
        }
    }
    
    [_asset loadValuesAsynchronouslyForKeys:@[@"availableMetadataFormats"] completionHandler:^{
        
        AVKeyValueStatus status = [_asset statusOfValueForKey:@"availableMetadataFormats" error:nil];
        if (status == AVKeyValueStatusLoaded) {
            for (AVMetadataFormat format in _asset.availableMetadataFormats) {
                if ([@[AVMetadataFormatQuickTimeMetadata, AVMetadataFormatiTunesMetadata, AVMetadataFormatID3Metadata] containsObject:format]) {
                    _metadata = [[MYMetadata alloc] initWithItems:[self.asset metadataForFormat:format]];
                    
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(YES);
                }
            });
        }
    }];
}

- (void)saveWithCompletionHandler:(void (^)(BOOL))handler
{
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:_asset presetName:AVAssetExportPresetPassthrough];
    session.outputURL      = [self tempURL];
    session.outputFileType = [self fileType];
    session.metadata       = [self.metadata metadataItems];

    [session exportAsynchronouslyWithCompletionHandler:^{
        if (session.status == AVAssetExportSessionStatusCompleted) {
            [[NSFileManager defaultManager] removeItemAtURL:_url error:nil];
            [[NSFileManager defaultManager] moveItemAtURL:session.outputURL toURL:_url error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(YES);
            }
        });
    }];
}


#pragma mark - Private Method
- (NSURL *)tempURL
{
    NSString *tempDir = NSTemporaryDirectory();
    NSString *ext = [[_url lastPathComponent] pathExtension];
    NSString *tempName = [NSString stringWithFormat:@"temp.%@", ext];
    NSString *tempPath = [tempDir stringByAppendingPathComponent:tempName];
    return [NSURL fileURLWithPath:tempPath];
}

- (NSString *)fileType
{
    NSString *ext = [[_url lastPathComponent] pathExtension];
    NSString *type = nil;
    if ([ext isEqualToString:@"m4a"]) {
        type = AVFileTypeAppleM4A;
    } else if ([ext isEqualToString:@"m4v"]) {
        type = AVFileTypeAppleM4V;
    } else if ([ext isEqualToString:@"mov"]) {
        type = AVFileTypeQuickTimeMovie;
    } else if ([ext isEqualToString:@"mp4"]) {
        type = AVFileTypeMPEG4;
    } else {
        type = AVFileTypeMPEGLayer3;
    }
    return type;
}


@end
