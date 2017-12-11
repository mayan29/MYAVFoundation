//
//  MYMetadata.m
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/5.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MYMetadata.h"
#import "AVMetadataItem+Extension.h"
#import "MYMetadataKeys.h"
#import "MYMetadataConverterFactory.h"

@interface MYMetadata ()

@property (nonatomic, strong) NSDictionary *keyMapping;
@property (nonatomic, strong) NSMutableDictionary *metadatas;

@end

@implementation MYMetadata

#pragma mark - Init
- (instancetype)initWithItems:(NSArray<AVMetadataItem *> *)items
{
    self = [super init];
    if (self) {
        for (AVMetadataItem *item in items) {
            [self addMetadataItem:item];
        }
    }
    return self;
}


#pragma mark - Public Method
// 获取
- (void)addMetadataItem:(AVMetadataItem *)item
{    
    NSString *normalizedKey = self.keyMapping[item.commonKey] ?: self.keyMapping[item.keyString];
    if (normalizedKey) {
        
        // 获取指定类型控制器
        id <MYMetadataConverter> converter = [MYMetadataConverterFactory converterForKey:normalizedKey];
        
        // Extract the value from the AVMetadataItem instance and
        // convert it into a format suitable for presentation.
        id value = [converter displayValueFromMetadataItem:item];
        [self setValue:value forKey:normalizedKey];
        
        // Store the AVMetadataItem away for later use
        self.metadatas[normalizedKey] = item;
    }
}

// 保存
- (NSArray<AVMetadataItem *> *)metadataItems
{
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *key in _metadatas) {
        id <MYMetadataConverter> converter = [MYMetadataConverterFactory converterForKey:key];
        
        id value = [self valueForKey:key];
        AVMetadataItem *item = [converter metadataItemFromDisplayValue:value withMetadataItem:_metadatas[key]];
        if (items) {
            [items addObject:item];
        }
    }
    return items;
}


#pragma mark - Lazy Load
- (NSDictionary *)keyMapping
{
    if (!_keyMapping) {
        _keyMapping = @{
                        // Artwork Mapping
                        AVMetadataCommonKeyArtwork             : MYMetadataKeyArtwork,
                        
                        // Title Mapping
                        AVMetadataCommonKeyTitle               : MYMetadataKeyTitle,
                        
                        // Artist Mapping
                        AVMetadataCommonKeyArtist              : MYMetadataKeyArtist,
                        AVMetadataQuickTimeMetadataKeyProducer : MYMetadataKeyArtist,
                        
                        // Album Artist Mapping
                        AVMetadataID3MetadataKeyBand           : MYMetadataKeyAlbumArtist,
                        AVMetadataiTunesMetadataKeyAlbumArtist : MYMetadataKeyAlbumArtist,
                        @"TP2"                                 : MYMetadataKeyAlbumArtist,
                        
                        // Album Mapping
                        AVMetadataCommonKeyAlbumName           : MYMetadataKeyAlbum,
                        
                        // Comments Mapping
                        AVMetadataCommonKeyDescription         : MYMetadataKeyComments,
                        AVMetadataiTunesMetadataKeyUserComment : MYMetadataKeyComments,
                        AVMetadataID3MetadataKeyComments       : MYMetadataKeyComments,
                        @"ldes"                                : MYMetadataKeyComments,
                        @"COM"                                 : MYMetadataKeyComments,
                        
                        // Track Number Mapping
                        AVMetadataiTunesMetadataKeyTrackNumber : MYMetadataKeyTrack,
                        AVMetadataID3MetadataKeyTrackNumber    : MYMetadataKeyTrack,
                        @"TRK"                                 : MYMetadataKeyTrack,
                        
                        // Year Mapping
                        AVMetadataCommonKeyCreationDate        : MYMetadataKeyYear,
                        AVMetadataID3MetadataKeyYear           : MYMetadataKeyYear,
                        AVMetadataQuickTimeMetadataKeyYear     : MYMetadataKeyYear,
                        AVMetadataID3MetadataKeyRecordingTime  : MYMetadataKeyYear,
                        @"TYE"                                 : MYMetadataKeyYear,
                        
                        // BPM Mapping
                        AVMetadataiTunesMetadataKeyBeatsPerMin : MYMetadataKeyBPM,
                        AVMetadataID3MetadataKeyBeatsPerMinute : MYMetadataKeyBPM,
                        @"TBP"                                 : MYMetadataKeyBPM,
                        
                        // Grouping Mapping
                        AVMetadataiTunesMetadataKeyGrouping    : MYMetadataKeyGrouping,
                        AVMetadataCommonKeySubject             : MYMetadataKeyGrouping,
                        @"@grp"                                : MYMetadataKeyGrouping,
                        
                        // Composer Mapping
                        AVMetadataQuickTimeMetadataKeyDirector : MYMetadataKeyComposer,
                        AVMetadataiTunesMetadataKeyComposer    : MYMetadataKeyComposer,
                        AVMetadataCommonKeyCreator             : MYMetadataKeyComposer,
                        
                        // Disc Number Mapping
                        AVMetadataiTunesMetadataKeyDiscNumber  : MYMetadataKeyDisc,
                        AVMetadataID3MetadataKeyPartOfASet     : MYMetadataKeyDisc,
                        @"TPA"                                 : MYMetadataKeyDisc,
                        
                        // Genre Mapping
                        AVMetadataQuickTimeMetadataKeyGenre    : MYMetadataKeyGenre,
                        AVMetadataiTunesMetadataKeyUserGenre   : MYMetadataKeyGenre,
                        AVMetadataCommonKeyType                : MYMetadataKeyGenre
                        };
    }
    return _keyMapping;
}

- (NSMutableDictionary *)metadatas
{
    if (!_metadatas) {
        _metadatas = [NSMutableDictionary dictionary];
    }
    return _metadatas;
}


@end
