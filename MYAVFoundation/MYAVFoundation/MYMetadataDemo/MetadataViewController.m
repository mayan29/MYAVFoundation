//
//  MetadataViewController.m
//  MYAVFoundation
//
//  Created by mayan on 2017/12/11.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MetadataViewController.h"
#import "DetailViewController.h"

@interface MetadataViewController ()

@property (nonatomic, strong) NSArray *names;

@end

@implementation MetadataViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 将项目中的音视频文件复制到 Document 中
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    for (NSString *name in self.names) {
        NSString *toPath = [document stringByAppendingPathComponent:name];
        if (![[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
            NSURL *atURL = [[NSBundle mainBundle] URLForResource:name withExtension:nil];
            NSURL *toURL = [NSURL fileURLWithPath:toPath];
            [[NSFileManager defaultManager] copyItemAtURL:atURL toURL:toURL error:nil];
        }
    }
}


#pragma mark - Lazy load
- (NSArray *)names
{
    if (!_names) {
        _names = @[@"01 Demo AAC.m4a",
                   @"02 Demo ID3v2.2.mp3",
                   @"03 Demo ID3v2.3.mp3",
                   @"04 Demo ID3v2.4.mp3",
                   @"Charlie The Unicorn.m4v",
                   @"Hubblecast.mov"];
    }
    return _names;
}


#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.names[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.title = self.names[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
