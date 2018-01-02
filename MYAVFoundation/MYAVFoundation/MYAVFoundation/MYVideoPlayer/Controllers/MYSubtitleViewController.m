//
//  MYSubtitleViewController.m
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/29.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MYSubtitleViewController.h"

@interface MYSubtitleViewController ()

@property (nonatomic, strong) NSArray  *subtitles;
@property (nonatomic, strong) NSString *selectedSubtitle;

@end

@implementation MYSubtitleViewController


+ (instancetype)tableViewWithSubtitles:(NSArray *)subtitles selectedSubtitle:(NSString *)selectedSubtitle
{
    MYSubtitleViewController *vc = [[MYSubtitleViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.subtitles = subtitles;
    vc.selectedSubtitle = [subtitles containsObject:selectedSubtitle] ? selectedSubtitle : subtitles.firstObject;
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    
}

- (void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)commit {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate subtitleViewController:self subtitleSelected:self.selectedSubtitle];
    }];
}


#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _subtitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MYSubtitleViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSString *subtitle = _subtitles[indexPath.row];
    
    cell.textLabel.text = subtitle;
    cell.accessoryType = [subtitle isEqualToString:_selectedSubtitle] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedSubtitle = _subtitles[indexPath.row];
    
    [tableView reloadData];
}


@end
