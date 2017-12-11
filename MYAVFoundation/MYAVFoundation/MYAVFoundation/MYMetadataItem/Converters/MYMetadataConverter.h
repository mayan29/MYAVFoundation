//
//  MYMetadataConverter.h
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/6.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@protocol MYMetadataConverter <NSObject>

- (id)displayValueFromMetadataItem:(AVMetadataItem *)item;

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value
                                withMetadataItem:(AVMetadataItem *)item;

@end
