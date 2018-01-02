//
//  VideoPlayerViewController.m
//  MYAVFoundation
//
//  Created by mayan on 2018/1/2.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "MYPlayerViewController.h"

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = @"点击播放";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    MYPlayerViewController *vc = [[MYPlayerViewController alloc] init];
    vc.assetURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"hubblecast" ofType:@"m4v"]];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
