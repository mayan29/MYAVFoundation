//
//  MYSubtitleViewController.h
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/29.
//  Copyright © 2017年 mayan. All rights reserved.
//
//  选择字幕语言列表

#import <UIKit/UIKit.h>

@class MYSubtitleViewController;
@protocol MYSubtitleViewControllerDelegate <NSObject>

- (void)subtitleViewController:(MYSubtitleViewController *)viewController subtitleSelected:(NSString *)subtitle;

@end


@interface MYSubtitleViewController : UITableViewController

+ (instancetype)tableViewWithSubtitles:(NSArray *)subtitles selectedSubtitle:(NSString *)selectedSubtitle;

@property (nonatomic, weak) id<MYSubtitleViewControllerDelegate> delegate;

@end
