//
//  MYMetadataConverterFactory.m
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/6.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MYMetadataConverterFactory.h"
#import "MYDefaultMetadataConverter.h"
#import "MYMetadataKeys.h"

@implementation MYMetadataConverterFactory

+ (id<MYMetadataConverter>)converterForKey:(NSString *)key {
    
    id <MYMetadataConverter> converter = nil;
    
    if ([key isEqualToString:MYMetadataKeyArtwork]) {
        converter = [[MYArtworkMetadataConverter alloc] init];
    }
    else if ([key isEqualToString:MYMetadataKeyTrack]) {
        converter = [[MYTrackMetadataConverter alloc] init];
    }
    else if ([key isEqualToString:MYMetadataKeyDisc]) {
        converter = [[MYDiscMetadataConverter alloc] init];
    }
    else if ([key isEqualToString:MYMetadataKeyGenre]) {
        converter = [[MYGenreMetadataConverter alloc] init];
    }
    else if ([key isEqualToString:MYMetadataKeyBPM]) {
        converter = [[MYBpmMetadataConverter alloc] init];
    }
    else {
        converter = [[MYDefaultMetadataConverter alloc] init];
    }
    
    return converter;
}

@end
