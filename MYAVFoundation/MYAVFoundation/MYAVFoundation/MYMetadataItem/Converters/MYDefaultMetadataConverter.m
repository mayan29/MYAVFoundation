//
//  MYDefaultMetadataConverter.m
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/6.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MYDefaultMetadataConverter.h"
#import "MYGenre.h"


@implementation MYDefaultMetadataConverter

- (id)displayValueFromMetadataItem:(AVMetadataItem *)item
{
    return item.value;
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    metadataItem.value = value;
    return metadataItem;
}

@end



@implementation MYArtworkMetadataConverter

- (id)displayValueFromMetadataItem:(AVMetadataItem *)item
{
    return [[UIImage alloc] initWithData:(NSData *)item.value];
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    metadataItem.value = UIImagePNGRepresentation(value);
    return metadataItem;
}

@end



@implementation MYTrackMetadataConverter

- (id)displayValueFromMetadataItem:(AVMetadataItem *)item
{
    // 对于 M4A 文件，value 为 NSData，这是 4 个 16 位 big endian 数字数组的 16 进制表现形式。
    // 数组中的第 2 个和第 3 个元素分别包含音轨编号和音轨计数值。
    if ([item.value isKindOfClass:[NSData class]]) {
        NSData *data = (NSData *)item.value;
        if (data.length == 8) {
            uint16_t *values = (uint16_t *)[data bytes];
            // 如果值不为 0，使用 `CFSwapInt16BigToHost()` 函数将 endian 转换为 little endian 格式
            NSNumber *number = @(CFSwapInt16BigToHost(values[1]));
            NSNumber *count  = @(CFSwapInt16BigToHost(values[2]));
            return [NSString stringWithFormat:@"%@/%@", number, count];
        } else return nil;
    } else {
        return item.value;
    }
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    NSString *trackNumberString = [(NSString *)value componentsSeparatedByString:@"/"].firstObject;
    NSString *trackCountString = [(NSString *)value componentsSeparatedByString:@"/"].lastObject;
    NSNumber *trackNumber = [[NSNumber alloc] initWithInteger:trackNumberString.integerValue];
    NSNumber *trackCount = [[NSNumber alloc] initWithInteger:trackCountString.integerValue];
    
    uint16_t values[4] = {0};
    if (trackNumber && ![trackNumber isKindOfClass:[NSNull class]]) {
        values[1] = CFSwapInt16HostToBig(trackNumber.unsignedIntegerValue);
    }
    if (trackCount && ![trackCount isKindOfClass:[NSNull class]]) {
        values[2] = CFSwapInt16HostToBig(trackCount.unsignedIntegerValue);
    }
    size_t length = sizeof(values);
    
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    metadataItem.value = [NSData dataWithBytes:values length:length];
    return metadataItem;
}

@end



@implementation MYDiscMetadataConverter

- (id)displayValueFromMetadataItem:(AVMetadataItem *)item
{
    if ([item.value isKindOfClass:[NSData class]]) {
        NSData *data = (NSData *)item.value;
        if (data.length == 6) {
            uint16_t *values = (uint16_t *)[data bytes];
            NSNumber *number = @(CFSwapInt16BigToHost(values[1]));
            NSNumber *count  = @(CFSwapInt16BigToHost(values[2]));
            return [NSString stringWithFormat:@"%@/%@", number, count];
        } else return nil;
    } else {
        return item.value;
    }
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    NSString *discNumberString = [(NSString *)value componentsSeparatedByString:@"/"].firstObject;
    NSString *discCountString = [(NSString *)value componentsSeparatedByString:@"/"].lastObject;
    NSNumber *discNumber = [[NSNumber alloc] initWithInteger:discNumberString.integerValue];
    NSNumber *discCount = [[NSNumber alloc] initWithInteger:discCountString.integerValue];
    
    uint16_t values[3] = {0};
    if (discNumber && ![discNumber isKindOfClass:[NSNull class]]) {
        values[1] = CFSwapInt16HostToBig(discNumber.unsignedIntegerValue);
    }
    if (discCount && ![discCount isKindOfClass:[NSNull class]]) {
        values[2] = CFSwapInt16HostToBig(discCount.unsignedIntegerValue);
    }
    size_t length = sizeof(values);
    
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    metadataItem.value = [NSData dataWithBytes:values length:length];
    return metadataItem;
}

@end



@implementation MYGenreMetadataConverter

- (id)displayValueFromMetadataItem:(AVMetadataItem *)item
{
    if ([item.value isKindOfClass:[NSData class]]) {
        NSData *data = (NSData *)item.value;
        if (data.length == 2) {
            uint16_t *values = (uint16_t *)[data bytes];
            uint16_t genreIndex = CFSwapInt16BigToHost(values[0]);
            return [MYGenre iTunesGenreWithIndex:@(genreIndex).unsignedIntValue];
        } else return nil;
    } else {
        if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
            // ID3v2.4 stores the genre as an index value
            if (item.numberValue) {
                return [MYGenre id3GenreWithIndex:item.numberValue.unsignedIntValue];
            } else {
                return [MYGenre id3GenreWithName:item.stringValue];
            }
        } else {
            return [MYGenre videoGenreWithName:item.stringValue];
        }
    }
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    
    MYGenre *genre = (MYGenre *)value;
    if ([item.value isKindOfClass:[NSString class]]) {
        metadataItem.value = genre.name;
    }
    else if ([item.value isKindOfClass:[NSData class]]) {
        NSData *data = item.dataValue;
        if (data.length == 2) {
            uint16_t value = CFSwapInt16HostToBig(genre.index + 1);
            size_t length = sizeof(value);
            metadataItem.value = [NSData dataWithBytes:&value length:length];
        }
    }
    return metadataItem;
}

@end



@implementation MYBpmMetadataConverter

- (id)displayValueFromMetadataItem:(AVMetadataItem *)item
{
    if ([item.value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", item.value];
    } else {
        return item.value;
    }
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    
    NSString *valueString = (NSString *)value;
    if ([item.value isKindOfClass:[NSNumber class]]) {
        metadataItem.value = [[NSNumber alloc] initWithInteger:valueString.integerValue];
    } else {
        metadataItem.value = value;
    }
    return metadataItem;
}

@end
