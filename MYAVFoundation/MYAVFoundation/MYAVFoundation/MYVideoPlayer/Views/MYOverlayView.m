//
//  MYOverlayView.m
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/27.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import "MYOverlayView.h"
#import "MYSubtitleViewController.h"
#import "MYStillsListViewController.h"

@interface MYOverlayView () <MYSubtitleViewControllerDelegate, MYStillsListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView      *upBgView;
@property (weak, nonatomic) IBOutlet UIView      *downBgView;
@property (weak, nonatomic) IBOutlet UILabel     *TitleLabel;
@property (weak, nonatomic) IBOutlet UIButton    *closeButton;
@property (weak, nonatomic) IBOutlet UIButton    *playButton;
@property (weak, nonatomic) IBOutlet UILabel     *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel     *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider    *progressSlider;
@property (weak, nonatomic) IBOutlet UIView      *popupBgView;
@property (weak, nonatomic) IBOutlet UILabel     *popupLabel;
@property (weak, nonatomic) IBOutlet UIImageView *popupImageView;
@property (weak, nonatomic) IBOutlet UIButton    *subtitlesButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popupBgViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upBgViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downBgViewBottom;

@property (nonatomic, strong) NSArray  *subtitles;         // 字幕
@property (nonatomic, strong) NSString *selectedSubtitle;  // 当前选择的字幕语言
@property (nonatomic, strong) NSArray  *stillsImages;      // 剧照

@property (nonatomic, assign) BOOL toolBarHidden;

@end

@implementation MYOverlayView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.closeButton setImage:[UIImage imageNamed:@"MYVideoPlayerResource.bundle/close"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"MYVideoPlayerResource.bundle/play"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"MYVideoPlayerResource.bundle/pause"] forState:UIControlStateSelected];
    self.popupImageView.image = [UIImage imageNamed:@"MYVideoPlayerResource.bundle/dialogBox"];
    
    [self.progressSlider addTarget:self action:@selector(changePopupLabel:) forControlEvents:UIControlEventValueChanged];
    [self.progressSlider addTarget:self action:@selector(hidePopupLabel:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider addTarget:self action:@selector(showPopupLabel:) forControlEvents:UIControlEventTouchDown];
    
    self.playButton.selected = YES;
}


#pragma mark - Button Click

- (IBAction)play:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        if ([self.delegate respondsToSelector:@selector(play)]) {
            [self.delegate performSelector:@selector(play)];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(pause)]) {
            [self.delegate performSelector:@selector(pause)];
        }
    }
}

- (IBAction)close:(UIButton *)sender {
    
    [self.delegate stop];
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

// 点击字幕 button
- (IBAction)subtitlesButton:(UIButton *)sender {
    
    [self.delegate pause];
    
    MYSubtitleViewController *vc =
        [MYSubtitleViewController tableViewWithSubtitles:_subtitles selectedSubtitle:_selectedSubtitle];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window.rootViewController.presentedViewController presentViewController:nav animated:YES completion:nil];
}

// 点击剧照 button
- (IBAction)stillsButton:(UIButton *)sender {
    
    [self.delegate pause];
    
    MYStillsListViewController *vc =
        [[MYStillsListViewController alloc] initWithImages:_stillsImages];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window.rootViewController.presentedViewController presentViewController:nav animated:YES completion:nil];
}


// 滑动滑块
- (void)changePopupLabel:(UISlider *)slider {
    
    self.popupBgView.hidden = NO;
    
    // 改变 popupBgView 的位置
    CGRect thumbRect = [slider thumbRectForBounds:slider.bounds trackRect:slider.bounds value:slider.value];
    self.popupBgViewLeading.constant = thumbRect.origin.x - (self.popupBgView.bounds.size.width - thumbRect.size.width) * 0.5;
    
    self.currentTimeLabel.text = [self formatSeconds:slider.value];
    self.remainingTimeLabel.text = [self formatSeconds:(slider.maximumValue - slider.value)];
    
    [self setScrubbingTime:slider.value];
    [self.delegate scrubbedToTime:slider.value];
}

// 显示滑块
- (void)showPopupLabel:(UISlider *)slider {
    
    self.popupBgView.hidden = NO;
    
    [self.delegate pause];
}

// 隐藏滑块
- (void)hidePopupLabel:(UISlider *)slider  {
    
    self.popupBgView.hidden = YES;
    
    [self.delegate play];
}


#pragma mark - MYSubtitleViewControllerDelegate

- (void)subtitleViewController:(MYSubtitleViewController *)viewController subtitleSelected:(NSString *)subtitle {
    
    _selectedSubtitle = subtitle;
    
    [self.delegate subtitleSelected:subtitle];
    [self.delegate play];
}

#pragma mark - MYStillsListViewControllerDelegate

- (void)dismissWithStillsListViewController:(MYStillsListViewController *)viewController {
    
    [self.delegate play];
}


#pragma mark - MYTransport

- (void)setTitle:(NSString *)title {
    
    self.TitleLabel.text = title;
}

- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
    
    self.currentTimeLabel.text = [self formatSeconds:time];
    self.remainingTimeLabel.text = [self formatSeconds:(duration - time)];
    
    if (self.progressSlider.minimumValue != 0.0f) {
        self.progressSlider.minimumValue = 0.0f;
    }
    if (self.progressSlider.maximumValue != duration) {
        self.progressSlider.maximumValue = duration;
    }
    [self.progressSlider setValue:(time) animated:YES];
}

- (void)playbackComplete {
    
    self.progressSlider.value = 0.0f;
    self.playButton.selected = NO;
}

// 设置字幕
- (void)setSubtitles:(NSArray *)subtitles {
    
    NSMutableArray *filtered = [NSMutableArray arrayWithObject:@"None"];
    for (NSString *sub in subtitles) {
        if ([sub rangeOfString:@"Forced"].location == NSNotFound) {
            [filtered addObject:sub];
        }
    }
    _subtitles = filtered;
    _subtitlesButton.hidden = (_subtitles.count <= 1);
}

- (void)setStillsImages:(NSArray *)images
{
    _stillsImages = images;
}


#pragma mark - Private Method

- (NSString *)formatSeconds:(NSInteger)value {
    
    NSInteger seconds = value % 60;
    NSInteger minutes = value / 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
}

- (void)setScrubbingTime:(NSTimeInterval)time {
    
    self.popupLabel.text = [self formatSeconds:time];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint(self.upBgView.frame, point)) return;
    if (CGRectContainsPoint(self.downBgView.frame, point)) return;
    
    
    _toolBarHidden = !_toolBarHidden;
    
    if (_toolBarHidden) {
        _upBgViewTop.constant = -_upBgView.bounds.size.height;
        _downBgViewBottom.constant = -_downBgView.bounds.size.height;
    } else {
        _upBgViewTop.constant = 0;
        _downBgViewBottom.constant = 0;
    }
}

@end
