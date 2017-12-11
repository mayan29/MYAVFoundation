//
//  MYGenre.m
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/5.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MYGenre.h"

@implementation MYGenre

+ (NSArray *)audioGenres {
    static dispatch_once_t predicate;
    static NSArray *musicGenres = nil;
    dispatch_once(&predicate, ^{
        musicGenres = @[[[MYGenre alloc] initWithIndex:0 name:@"Blues"],
                        [[MYGenre alloc] initWithIndex:1 name:@"Classic Rock"],
                        [[MYGenre alloc] initWithIndex:2 name:@"Country"],
                        [[MYGenre alloc] initWithIndex:3 name:@"Dance"],
                        [[MYGenre alloc] initWithIndex:4 name:@"Disco"],
                        [[MYGenre alloc] initWithIndex:5 name:@"Funk"],
                        [[MYGenre alloc] initWithIndex:6 name:@"Grunge"],
                        [[MYGenre alloc] initWithIndex:7 name:@"Hip-Hop"],
                        [[MYGenre alloc] initWithIndex:8 name:@"Jazz"],
                        [[MYGenre alloc] initWithIndex:9 name:@"Metal"],
                        [[MYGenre alloc] initWithIndex:10 name:@"New Age"],
                        [[MYGenre alloc] initWithIndex:11 name:@"Oldies"],
                        [[MYGenre alloc] initWithIndex:12 name:@"Other"],
                        [[MYGenre alloc] initWithIndex:13 name:@"Pop"],
                        [[MYGenre alloc] initWithIndex:14 name:@"R&B"],
                        [[MYGenre alloc] initWithIndex:15 name:@"Rap"],
                        [[MYGenre alloc] initWithIndex:16 name:@"Reggae"],
                        [[MYGenre alloc] initWithIndex:17 name:@"Rock"],
                        [[MYGenre alloc] initWithIndex:18 name:@"Techno"],
                        [[MYGenre alloc] initWithIndex:19 name:@"Industrial"],
                        [[MYGenre alloc] initWithIndex:20 name:@"Alternative"],
                        [[MYGenre alloc] initWithIndex:21 name:@"Ska"],
                        [[MYGenre alloc] initWithIndex:22 name:@"Death Metal"],
                        [[MYGenre alloc] initWithIndex:23 name:@"Pranks"],
                        [[MYGenre alloc] initWithIndex:24 name:@"Soundtrack"],
                        [[MYGenre alloc] initWithIndex:25 name:@"Euro-Techno"],
                        [[MYGenre alloc] initWithIndex:26 name:@"Ambient"],
                        [[MYGenre alloc] initWithIndex:27 name:@"Trip-Hop"],
                        [[MYGenre alloc] initWithIndex:28 name:@"Vocal"],
                        [[MYGenre alloc] initWithIndex:29 name:@"Jazz+Funk"],
                        [[MYGenre alloc] initWithIndex:30 name:@"Fusion"],
                        [[MYGenre alloc] initWithIndex:31 name:@"Trance"],
                        [[MYGenre alloc] initWithIndex:32 name:@"Classical"],
                        [[MYGenre alloc] initWithIndex:33 name:@"Instrumental"],
                        [[MYGenre alloc] initWithIndex:34 name:@"Acid"],
                        [[MYGenre alloc] initWithIndex:35 name:@"House"],
                        [[MYGenre alloc] initWithIndex:36 name:@"Game"],
                        [[MYGenre alloc] initWithIndex:37 name:@"Sound Clip"],
                        [[MYGenre alloc] initWithIndex:38 name:@"Gospel"],
                        [[MYGenre alloc] initWithIndex:39 name:@"Noise"],
                        [[MYGenre alloc] initWithIndex:40 name:@"AlternRock"],
                        [[MYGenre alloc] initWithIndex:41 name:@"Bass"],
                        [[MYGenre alloc] initWithIndex:42 name:@"Soul"],
                        [[MYGenre alloc] initWithIndex:43 name:@"Punk"],
                        [[MYGenre alloc] initWithIndex:44 name:@"Space"],
                        [[MYGenre alloc] initWithIndex:45 name:@"Meditative"],
                        [[MYGenre alloc] initWithIndex:46 name:@"Instrumental Pop"],
                        [[MYGenre alloc] initWithIndex:47 name:@"Instrumental Rock"],
                        [[MYGenre alloc] initWithIndex:48 name:@"Ethnic"],
                        [[MYGenre alloc] initWithIndex:49 name:@"Gothic"],
                        [[MYGenre alloc] initWithIndex:50 name:@"Darkwave"],
                        [[MYGenre alloc] initWithIndex:51 name:@"Techno-Industrial"],
                        [[MYGenre alloc] initWithIndex:52 name:@"Electronic"],
                        [[MYGenre alloc] initWithIndex:53 name:@"Pop-Folk"],
                        [[MYGenre alloc] initWithIndex:54 name:@"Eurodance"],
                        [[MYGenre alloc] initWithIndex:55 name:@"Dream"],
                        [[MYGenre alloc] initWithIndex:56 name:@"Southern Rock"],
                        [[MYGenre alloc] initWithIndex:57 name:@"Comedy"],
                        [[MYGenre alloc] initWithIndex:58 name:@"Cult"],
                        [[MYGenre alloc] initWithIndex:59 name:@"Gangsta"],
                        [[MYGenre alloc] initWithIndex:60 name:@"Top 40"],
                        [[MYGenre alloc] initWithIndex:61 name:@"Christian Rap"],
                        [[MYGenre alloc] initWithIndex:62 name:@"Pop/Funk"],
                        [[MYGenre alloc] initWithIndex:63 name:@"Jungle"],
                        [[MYGenre alloc] initWithIndex:64 name:@"Native American"],
                        [[MYGenre alloc] initWithIndex:65 name:@"Cabaret"],
                        [[MYGenre alloc] initWithIndex:66 name:@"New Wave"],
                        [[MYGenre alloc] initWithIndex:67 name:@"Psychedelic"],
                        [[MYGenre alloc] initWithIndex:68 name:@"Rave"],
                        [[MYGenre alloc] initWithIndex:69 name:@"Showtunes"],
                        [[MYGenre alloc] initWithIndex:70 name:@"Trailer"],
                        [[MYGenre alloc] initWithIndex:71 name:@"Lo-Fi"],
                        [[MYGenre alloc] initWithIndex:72 name:@"Tribal"],
                        [[MYGenre alloc] initWithIndex:73 name:@"Acid Punk"],
                        [[MYGenre alloc] initWithIndex:74 name:@"Acid Jazz"],
                        [[MYGenre alloc] initWithIndex:75 name:@"Polka"],
                        [[MYGenre alloc] initWithIndex:76 name:@"Retro"],
                        [[MYGenre alloc] initWithIndex:77 name:@"Musical"],
                        [[MYGenre alloc] initWithIndex:78 name:@"Rock & Roll"],
                        [[MYGenre alloc] initWithIndex:79 name:@"Hard Rock"],
                        [[MYGenre alloc] initWithIndex:80 name:@"Folk"],
                        [[MYGenre alloc] initWithIndex:81 name:@"Folk-Rock"],
                        [[MYGenre alloc] initWithIndex:82 name:@"National Folk"],
                        [[MYGenre alloc] initWithIndex:83 name:@"Swing"],
                        [[MYGenre alloc] initWithIndex:84 name:@"Fast Fusion"],
                        [[MYGenre alloc] initWithIndex:85 name:@"Bebob"],
                        [[MYGenre alloc] initWithIndex:86 name:@"Latin"],
                        [[MYGenre alloc] initWithIndex:87 name:@"Revival"],
                        [[MYGenre alloc] initWithIndex:88 name:@"Celtic"],
                        [[MYGenre alloc] initWithIndex:89 name:@"Bluegrass"],
                        [[MYGenre alloc] initWithIndex:90 name:@"Avantgarde"],
                        [[MYGenre alloc] initWithIndex:91 name:@"Gothic Rock"],
                        [[MYGenre alloc] initWithIndex:92 name:@"Progressive Rock"],
                        [[MYGenre alloc] initWithIndex:93 name:@"Psychedelic Rock"],
                        [[MYGenre alloc] initWithIndex:94 name:@"Symphonic Rock"],
                        [[MYGenre alloc] initWithIndex:95 name:@"Slow Rock"],
                        [[MYGenre alloc] initWithIndex:96 name:@"Big Band"],
                        [[MYGenre alloc] initWithIndex:97 name:@"Chorus"],
                        [[MYGenre alloc] initWithIndex:98 name:@"Easy Listening"],
                        [[MYGenre alloc] initWithIndex:99 name:@"Acoustic"],
                        [[MYGenre alloc] initWithIndex:100 name:@"Humour"],
                        [[MYGenre alloc] initWithIndex:101 name:@"Speech"],
                        [[MYGenre alloc] initWithIndex:102 name:@"Chanson"],
                        [[MYGenre alloc] initWithIndex:103 name:@"Opera"],
                        [[MYGenre alloc] initWithIndex:104 name:@"Chamber Music"],
                        [[MYGenre alloc] initWithIndex:105 name:@"Sonata"],
                        [[MYGenre alloc] initWithIndex:106 name:@"Symphony"],
                        [[MYGenre alloc] initWithIndex:107 name:@"Booty Bass"],
                        [[MYGenre alloc] initWithIndex:108 name:@"Primus"],
                        [[MYGenre alloc] initWithIndex:109 name:@"Porn Groove"],
                        [[MYGenre alloc] initWithIndex:110 name:@"Satire"],
                        [[MYGenre alloc] initWithIndex:111 name:@"Slow Jam"],
                        [[MYGenre alloc] initWithIndex:112 name:@"Club"],
                        [[MYGenre alloc] initWithIndex:113 name:@"Tango"],
                        [[MYGenre alloc] initWithIndex:114 name:@"Samba"],
                        [[MYGenre alloc] initWithIndex:115 name:@"Folklore"],
                        [[MYGenre alloc] initWithIndex:116 name:@"Ballad"],
                        [[MYGenre alloc] initWithIndex:117 name:@"Power Ballad"],
                        [[MYGenre alloc] initWithIndex:118 name:@"Rhythmic Soul"],
                        [[MYGenre alloc] initWithIndex:119 name:@"Freestyle"],
                        [[MYGenre alloc] initWithIndex:120 name:@"Duet"],
                        [[MYGenre alloc] initWithIndex:121 name:@"Punk Rock"],
                        [[MYGenre alloc] initWithIndex:122 name:@"Drum Solo"],
                        [[MYGenre alloc] initWithIndex:123 name:@"A Capella"],
                        [[MYGenre alloc] initWithIndex:124 name:@"Euro-House"],
                        [[MYGenre alloc] initWithIndex:125 name:@"Dance Hall"]];
    });
    return musicGenres;
}

+ (NSArray *)videoGenres {
    static dispatch_once_t predicate;
    static NSArray *videoGenres = nil;
    dispatch_once(&predicate, ^{
        videoGenres = @[[[MYGenre alloc] initWithIndex:4000 name:@"Comedy"],
                        [[MYGenre alloc] initWithIndex:4001 name:@"Drama"],
                        [[MYGenre alloc] initWithIndex:4002 name:@"Animation"],
                        [[MYGenre alloc] initWithIndex:4003 name:@"Action & Adventure"],
                        [[MYGenre alloc] initWithIndex:4004 name:@"Classic"],
                        [[MYGenre alloc] initWithIndex:4005 name:@"Kids"],
                        [[MYGenre alloc] initWithIndex:4006 name:@"Nonfiction"],
                        [[MYGenre alloc] initWithIndex:4007 name:@"Reality TV"],
                        [[MYGenre alloc] initWithIndex:4008 name:@"Sci-Fi & Fantasy"],
                        [[MYGenre alloc] initWithIndex:4009 name:@"Sports"],
                        [[MYGenre alloc] initWithIndex:4010 name:@"Teens"],
                        [[MYGenre alloc] initWithIndex:4011 name:@"Latino TV"]];
    });
    return videoGenres;
}

+ (MYGenre *)id3GenreWithName:(NSString *)name {
    for (MYGenre *genre in [self audioGenres]) {
        if ([genre.name isEqualToString:name]) {
            return genre;
        }
    }
    return [[MYGenre alloc] initWithIndex:255 name:name];
}

+ (MYGenre *)id3GenreWithIndex:(NSUInteger)genreIndex {
    for (MYGenre *genre in [self audioGenres]) {
        if (genre.index == genreIndex) {
            return genre;
        }
    }
    return [[MYGenre alloc] initWithIndex:255 name:@"Custom"];
}

+ (MYGenre *)iTunesGenreWithIndex:(NSUInteger)genreIndex {
    return [self id3GenreWithIndex:genreIndex - 1];
}

+ (MYGenre *)videoGenreWithName:(NSString *)name {
    for (MYGenre *genre in [self videoGenres]) {
        if ([genre.name isEqualToString:name]) {
            return genre;
        }
    }
    return nil;
}

- (instancetype)initWithIndex:(NSUInteger)genreIndex name:(NSString *)name {
    self = [super init];
    if (self) {
        _index = genreIndex;
        _name = [name copy];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[MYGenre alloc] initWithIndex:_index name:_name];
}

- (NSString *)description {
    return self.name;
}

- (BOOL)isEqual:(id)other {
    if (self == other) {
        return YES;
    }
    if (!other || ![other isMemberOfClass:[self class]]) {
        return NO;
    }
    return self.index == [other index] && [self.name isEqual:[other name]];
}

- (NSUInteger)hash {
    NSUInteger prime = 37;
    NSUInteger hash = 0;
    hash += (_index + 1) * prime;
    hash += [self.name hash] * prime;
    return hash;
}


@end
