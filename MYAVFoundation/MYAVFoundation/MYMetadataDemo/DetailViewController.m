//
//  DetailViewController.m
//  MYAVMetaManager
//
//  Created by mayan on 2017/12/5.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "DetailViewController.h"
#import "MYMetadataItem.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView     *artwork;      // 封面
@property (weak, nonatomic) IBOutlet UITextField     *mediaTitle;   // 歌曲名称
@property (weak, nonatomic) IBOutlet UITextField     *artist;       // 演唱者
@property (weak, nonatomic) IBOutlet UITextField     *albumArtist;  // 主要演唱者（iTunes 特有）
@property (weak, nonatomic) IBOutlet UITextField     *album;        // 专辑名称
@property (weak, nonatomic) IBOutlet UITextField     *comments;     // 注释
@property (weak, nonatomic) IBOutlet UITextField     *track;        // 音轨号
@property (weak, nonatomic) IBOutlet UITextField     *year;         // 年份
@property (weak, nonatomic) IBOutlet UITextField     *bpm;          // 每分钟节拍数
@property (weak, nonatomic) IBOutlet UITextField     *grouping;     // 分组
@property (weak, nonatomic) IBOutlet UITextField     *composer;     // 作曲家，设计者
@property (weak, nonatomic) IBOutlet UITextField     *discNumber;   // 唱片
@property (weak, nonatomic) IBOutlet UITextField     *genre;        // 风格

@property (nonatomic, strong) MYMetadataItem *metadataItem;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取路径
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [document stringByAppendingPathComponent:self.title];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // 获取元数据
    _metadataItem = [[MYMetadataItem alloc] initWithURL:url];
    [_metadataItem prepareWithCompletionHandler:^(BOOL complete) {
        [self setupUI];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    // 保存元数据
    [self setupData];
    [_metadataItem saveWithCompletionHandler:^(BOOL complete) {
        [self setupUI];
    }];
}

- (void)setupUI
{
    _artwork.image    = _metadataItem.metadata.artwork;
    _mediaTitle.text  = _metadataItem.metadata.title;
    _artist.text      = _metadataItem.metadata.artist;
    _albumArtist.text = _metadataItem.metadata.albumArtist;
    _album.text       = _metadataItem.metadata.album;
    _comments.text    = _metadataItem.metadata.comments;
    _track.text       = _metadataItem.metadata.track;
    _year.text        = _metadataItem.metadata.year;
    _bpm.text         = _metadataItem.metadata.bpm;
    _grouping.text    = _metadataItem.metadata.grouping;
    _composer.text    = _metadataItem.metadata.composer;
    _discNumber.text  = _metadataItem.metadata.disc;
    _genre.text       = _metadataItem.metadata.genre.name;
}

- (void)setupData
{
    _metadataItem.metadata.artwork     = _artwork.image;
    _metadataItem.metadata.title       = _mediaTitle.text;
    _metadataItem.metadata.artist      = _artist.text;
    _metadataItem.metadata.albumArtist = _albumArtist.text;
    _metadataItem.metadata.album       = _album.text;
    _metadataItem.metadata.comments    = _comments.text;
    _metadataItem.metadata.track       = _track.text;
    _metadataItem.metadata.year        = _year.text;
    _metadataItem.metadata.bpm         = _bpm.text;
    _metadataItem.metadata.grouping    = _grouping.text;
    _metadataItem.metadata.composer    = _composer.text;
    _metadataItem.metadata.disc        = _discNumber.text;
    _metadataItem.metadata.genre.name  = _genre.text;
}


@end
