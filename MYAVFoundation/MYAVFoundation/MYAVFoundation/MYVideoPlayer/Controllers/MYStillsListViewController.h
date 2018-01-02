//
//  MYStillsListViewController.h
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/29.
//  Copyright © 2017年 mayan. All rights reserved.
//
//  剧照列表

#import <UIKit/UIKit.h>

@class MYStillsListViewController;
@protocol MYStillsListViewControllerDelegate <NSObject>

- (void)dismissWithStillsListViewController:(MYStillsListViewController *)viewController;

@end

@interface MYStillsListViewController : UIViewController

- (instancetype)initWithImages:(NSArray *)images;

@property (nonatomic, weak) id<MYStillsListViewControllerDelegate> delegate;


@end
