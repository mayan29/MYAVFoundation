//
//  VideoRecorderViewController.m
//  MYAVFoundation
//
//  Created by mayan on 2018/1/15.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "VideoRecorderViewController.h"
#import "MYRecorderViewController.h"

@implementation VideoRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 64, 49);
    button.center = self.view.center;
    [button setImage:[UIImage imageNamed:@"照相"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick {
    MYRecorderViewController *vc = [[MYRecorderViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
