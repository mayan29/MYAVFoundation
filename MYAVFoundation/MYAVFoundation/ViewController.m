//
//  ViewController.m
//  MYAVFoundation
//
//  Created by mayan on 2017/12/11.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "ViewController.h"
#import "MetadataViewController.h"
#import "VideoPlayerViewController.h"
#import "VideoRecorderViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"元数据获取、修改";
            break;
        case 1:
            cell.textLabel.text = @"视频播放";
            break;
        case 2:
            cell.textLabel.text = @"拍照、录制视频";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            MetadataViewController *vc = [[MetadataViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            VideoPlayerViewController *vc = [[VideoPlayerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            VideoRecorderViewController *vc = [[VideoRecorderViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}


@end
