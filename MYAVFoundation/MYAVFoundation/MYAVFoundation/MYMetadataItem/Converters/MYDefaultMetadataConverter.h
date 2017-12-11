//
//  MYDefaultMetadataConverter.h
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/6.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYMetadataConverter.h"

@interface MYDefaultMetadataConverter : NSObject <MYMetadataConverter>

@end

@interface MYArtworkMetadataConverter : NSObject <MYMetadataConverter>

@end

@interface MYTrackMetadataConverter : NSObject <MYMetadataConverter>

@end

@interface MYDiscMetadataConverter : NSObject <MYMetadataConverter>

@end

@interface MYGenreMetadataConverter : NSObject <MYMetadataConverter>

@end

@interface MYBpmMetadataConverter : NSObject <MYMetadataConverter>

@end
