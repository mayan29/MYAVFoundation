//
//  MYPlayerOverlayView.h
//  MYVideoPlayer
//
//  Created by mayan on 2017/12/27.
//  Copyright © 2017年 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYTransport.h"

@interface MYPlayerOverlayView : UIView <MYTransport>

@property (nonatomic, weak) id<MYTransportDelegate> delegate;

@end
