//
//  MYGenre.h
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/5.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYGenre : NSObject

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, copy) NSString *name;

+ (NSArray *)audioGenres;

+ (NSArray *)videoGenres;

+ (MYGenre *)id3GenreWithIndex:(NSUInteger)index;

+ (MYGenre *)id3GenreWithName:(NSString *)name;

+ (MYGenre *)iTunesGenreWithIndex:(NSUInteger)index;

+ (MYGenre *)videoGenreWithName:(NSString *)name;

@end
