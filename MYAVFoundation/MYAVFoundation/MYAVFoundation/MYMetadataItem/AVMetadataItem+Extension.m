//
//  AVMetadataItem+Extension.m
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/5.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "AVMetadataItem+Extension.h"

@implementation AVMetadataItem (Extension)

- (NSString *)keyString
{
    // 如果 key 是一个字符串，则原样返回
    if ([self.key isKindOfClass:[NSString class]]) {
        return (NSString *)self.key;
    }
    else if ([self.key isKindOfClass:[NSNumber class]]) {
        
        UInt32 keyValue = [(NSNumber *)self.key unsignedIntValue];
        
        // 大部分情况下，key 是一个 4 字符代码，比如 ©gen 或 TRAK，不过对于 mp3 文件，键值只有 3 个字符的长度
        size_t length = sizeof(UInt32);
        if ((keyValue >> 24) == 0) --length;
        if ((keyValue >> 16) == 0) --length;
        if ((keyValue >> 8)  == 0) --length;
        if ((keyValue >> 0)  == 0) --length;
        
        long address = (unsigned long)&keyValue;
        address += (sizeof(UInt32) - length);
        
        // 由于数字是 big endian 格式，因此使用 CFSwapInt32BigToHost() 函数将其转换为符合主 CPU 顺序的 little endian 格式
        keyValue = CFSwapInt32BigToHost(keyValue);
        
        // 创建一个字符数组，并使用 strncpy 函数将字符字节填充到该数组中
        char cstring[length];
        strncpy(cstring, (char *) address, length);
        cstring[length] = '\0';
        
        // 大量 QuickTime 用户数据和 iTunes key 的前缀都带有一个 © 符号
        // 不过 AVMetadataFormat.h 中定义 key 所使用的前缀符号为 @
        // 所以为了进行 key 常量字符串比较，需要先将 © 替换为 @
        if (cstring[0] == '\xA9') {
            cstring[0] = '@';
        }
        
        return [NSString stringWithCString:(char *) cstring
                                  encoding:NSUTF8StringEncoding];
    }
    else {
        return @"<unknown>";
    }
}


@end
