//
//  MYRecorderViewController.h
//  MYVideoRecorder
//
//  Created by mayan on 2018/1/11.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYRecorderViewController;
@protocol MYRecorderViewControllerDelegate <NSObject>

- (void)captureStillImage:(UIImage *)image;
- (void)captureVideoURL:(NSURL *)url;

@end

@interface MYRecorderViewController : UIViewController

@property (nonatomic, weak) id<MYRecorderViewControllerDelegate> delegate;

@end
