//
//  MYMetadataConverterFactory.h
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/6.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYMetadataConverter.h"

@interface MYMetadataConverterFactory : NSObject

+ (id <MYMetadataConverter>)converterForKey:(NSString *)key;

@end
