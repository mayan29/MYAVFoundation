//
//  MYStillsListViewController.m
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/29.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MYStillsListViewController.h"

@interface MYStillsListViewController ()

@property (nonatomic, strong) NSArray *images;

@end

@implementation MYStillsListViewController

- (instancetype)initWithImages:(NSArray *)images
{
    self = [super init];
    if (self) {
        _images = images;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * self.images.count, 0);
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < self.images.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(i * scrollView.bounds.size.width, 0, scrollView.bounds.size.width, scrollView.bounds.size.height);
        imgView.image = [self.images[i] valueForKey:@"image"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imgView];
    }
}

- (void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate dismissWithStillsListViewController:self];
    }];
}


@end
