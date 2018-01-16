//
//  MYRecorderOverlayView.m
//  MYVideoRecorder
//
//  Created by mayan on 2018/1/11.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "MYRecorderOverlayView.h"

#define MaxTimeLength       15    // 最长录像 15s
#define NormalInnerRadius   25    // 拍摄按钮默认状态：内圈半径
#define NormalOutsideRadius 35    // 拍摄按钮默认状态：外圈半径
#define ScaleInnerRadius    12.5  // 拍摄按钮缩放状态：内圈半径
#define ScaleOutsideRadius  50    // 拍摄按钮缩放状态：外圈半径
#define LineWidthProgress   5     // 录制视频进度条宽度
#define ProgressRadius      (ScaleOutsideRadius - LineWidthProgress + 2)

@interface MYRecorderOverlayView ()
{
    float _costTime;   // 耗时
}
@property (weak, nonatomic) IBOutlet UIButton *shootButton;   // 拍照
@property (weak, nonatomic) IBOutlet UILabel  *msgLabel;      // 轻触拍照，按住摄像
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;  // 取消拍照
@property (weak, nonatomic) IBOutlet UIButton *popButton;     // 退出拍照
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;  // 确认拍照
@property (weak, nonatomic) IBOutlet UIButton *switchButton;  // 切换摄像头

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseButtonCenterX;

@property (nonatomic, strong) CAShapeLayer *innerLayer;    // 拍照按钮 - 内圆
@property (nonatomic, strong) CAShapeLayer *outsideLayer;  // 拍照按钮 - 外圆
@property (nonatomic, strong) CAShapeLayer *progressLayer; // 拍照按钮 - 进度

@property (nonatomic, strong) UIBezierPath *normalInnerPath;   // 拍照按钮 - 默认状态下内圆 path
@property (nonatomic, strong) UIBezierPath *scaleInnerPath;    // 拍照按钮 - 缩放状态下内圆 path
@property (nonatomic, strong) UIBezierPath *normalOutsidePath; // 拍照按钮 - 默认状态下外圆 path
@property (nonatomic, strong) UIBezierPath *scaleOutsidePath;  // 拍照按钮 - 缩放状态下外圆 path
@property (nonatomic, strong) UIBezierPath *progressPath;      // 拍照按钮 - 进度条 path

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation MYRecorderOverlayView


#pragma mark - Init

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureOnBtnShoot:)];
    [self.shootButton addGestureRecognizer:gesture];
    
    [self.shootButton.layer addSublayer:self.outsideLayer];  // 外层圆
    [self.shootButton.layer addSublayer:self.innerLayer];    // 内层圆
    [self.shootButton.layer addSublayer:self.progressLayer]; // 进度层
    
    self.msgLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.msgLabel.layer.shadowRadius = 10;
    self.msgLabel.layer.shadowOpacity = 1.0;
    
    self.cancelButton.layer.cornerRadius = self.cancelButton.bounds.size.width * 0.5;
    self.cancelButton.layer.masksToBounds = YES;
    
    self.chooseButton.layer.cornerRadius = self.chooseButton.bounds.size.width * 0.5;
    self.chooseButton.layer.masksToBounds = YES;
    
    [self.cancelButton setImage:[UIImage imageNamed:@"MYVideoRecorderResource.bundle/回退"] forState:UIControlStateNormal];
    [self.popButton    setImage:[UIImage imageNamed:@"MYVideoRecorderResource.bundle/返回"] forState:UIControlStateNormal];
    [self.chooseButton setImage:[UIImage imageNamed:@"MYVideoRecorderResource.bundle/对号"] forState:UIControlStateNormal];
    [self.switchButton setImage:[UIImage imageNamed:@"MYVideoRecorderResource.bundle/切换摄像头"] forState:UIControlStateNormal];
}


#pragma mark - Gesture

// 拍照按钮 - 内圆
- (CAShapeLayer *)innerLayer {
    if (!_innerLayer) {
        _innerLayer = [CAShapeLayer layer];
        _innerLayer.fillColor = [UIColor whiteColor].CGColor;
        _innerLayer.path      = [self normalInnerPath].CGPath;
    }
    return _innerLayer;
}

// 拍照按钮 - 外圆
- (CAShapeLayer *)outsideLayer {
    if (!_outsideLayer) {
        _outsideLayer = [CAShapeLayer layer];
        _outsideLayer.fillColor = [UIColor colorWithRed:199.0/255.0 green:180.0/255.0 blue:172.0/255.0 alpha:1.0].CGColor;
        _outsideLayer.path      = [self normalOutsidePath].CGPath;
    }
    return _outsideLayer;
}

// 拍照按钮 - 进度
- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.lineWidth   = LineWidthProgress;
        _progressLayer.strokeColor = [UIColor colorWithRed:80.0/255.0 green:186.0/255.0 blue:93.0/255.0 alpha:1.0].CGColor;
        _progressLayer.fillColor   = [UIColor clearColor].CGColor;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd   = 0;
        _progressLayer.path        = [self progressPath].CGPath;
    }
    return _progressLayer;
}

// 拍照按钮 - 默认状态下内圆 path
- (UIBezierPath *)normalInnerPath {
    if (!_normalInnerPath) {
        _normalInnerPath = [UIBezierPath bezierPath];
        [_normalInnerPath addArcWithCenter:CGPointMake(NormalInnerRadius, NormalInnerRadius) radius:NormalInnerRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];        
    }
    return _normalInnerPath;
}

// 拍照按钮 - 缩放状态下内圆 path
- (UIBezierPath *)scaleInnerPath {
    if (!_scaleInnerPath) {
        _scaleInnerPath = [UIBezierPath bezierPath];
        [_scaleInnerPath addArcWithCenter:CGPointMake(NormalInnerRadius, NormalInnerRadius) radius:ScaleInnerRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    }
    return _scaleInnerPath;
}

// 拍照按钮 - 默认状态下外圆 path
- (UIBezierPath *)normalOutsidePath {
    if (!_normalOutsidePath) {
        _normalOutsidePath = [UIBezierPath bezierPath];
        [_normalOutsidePath addArcWithCenter:CGPointMake(NormalInnerRadius, NormalInnerRadius) radius:NormalOutsideRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    }
    return _normalOutsidePath;
}

// 拍照按钮 - 缩放状态下外圆 path
- (UIBezierPath *)scaleOutsidePath {
    if (!_scaleOutsidePath) {
        _scaleOutsidePath = [UIBezierPath bezierPath];
        [_scaleOutsidePath addArcWithCenter:CGPointMake(NormalInnerRadius, NormalInnerRadius) radius:ScaleOutsideRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    }
    return _scaleOutsidePath;
}

// 拍照按钮 - 进度条 path
- (UIBezierPath *)progressPath {
    if (!_progressPath) {
        _progressPath = [UIBezierPath bezierPath];
        [_progressPath addArcWithCenter:CGPointMake(NormalInnerRadius, NormalInnerRadius) radius:ProgressRadius startAngle:- M_PI / 2 endAngle:M_PI / 2 * 3 clockwise:YES];
    }
    return _progressPath;
}


#pragma mark - Public Method

- (void)hiddenMassege
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.msgLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [self.msgLabel removeFromSuperview];
        }];
    });
}


#pragma mark - Private Method

// 退出拍照
- (IBAction)popButtonClick:(UIButton *)sender {
    if (_delegate) {
        [_delegate dismissViewControllerClick];
    }
}

// 点击拍照
- (IBAction)shootButtonClick:(UIButton *)sender {
    
    _shootType = ShootType_Photo;
    
    if (_delegate) {
        [_delegate takePhotoClick];
        [self setNormalAnimation];
    }
}

// 长按录制视频
- (void)gestureOnBtnShoot:(UILongPressGestureRecognizer *)aGesture {
    
    _shootType = ShootType_Video;
    
    if (aGesture.state == UIGestureRecognizerStateBegan) {
        
        if (_delegate) {
            [_delegate startShootingClick];
            [self setScaleAnimation];
        }
    }
    else if (aGesture.state == UIGestureRecognizerStateEnded) {
        
        if (_delegate) {
            [_delegate endShootingClick];
            [self setNormalAnimation];
        }
    }
}

// 取消拍照或录像
- (IBAction)cancelButtonClick:(UIButton *)sender {

    [UIView animateWithDuration:0.25 animations:^{
        
        self.cancelButtonCenterX.constant = 0;
        self.chooseButtonCenterX.constant = 0;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        self.cancelButton.hidden = YES;
        self.chooseButton.hidden = YES;
        self.popButton.hidden    = NO;
        
        self.innerLayer.hidden   = NO;
        self.outsideLayer.hidden = NO;
        self.shootButton.hidden  = NO;
    }];
    
    // 取消录制视频
    if (_delegate && _shootType == ShootType_Video) {
        [_delegate cancelShootingClick];
    }
    // 取消拍照
    if (_delegate && _shootType == ShootType_Photo) {
        [_delegate cancelPhotoClick];
    }
}

// 确认拍照或录像
- (IBAction)chooseButtonClick:(UIButton *)sender {

    if (_delegate && _shootType == ShootType_Video) {
        [_delegate makeSureShootingClick];
    }
    // 取消拍照
    if (_delegate && _shootType == ShootType_Photo) {
        [_delegate selectedPhotoClick];
    }
}

// 切换摄像头
- (IBAction)switchCamera:(UIButton *)sender {
    
    if (_delegate) {
        [_delegate switchCameraClick];
    }
}

// 设置还原动画
- (void)setNormalAnimation {
    
    // 内圆半径复原
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration  = 0.25;
    animation.fromValue = (__bridge id _Nullable)[self scaleInnerPath].CGPath;
    animation.toValue   = (__bridge id _Nullable)[self normalInnerPath].CGPath;
    animation.fillMode  = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [_innerLayer addAnimation:animation forKey:@"innerScale"];
    
    // 外圆半径复原
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation2.duration  = 0.25;
    animation2.fromValue = (__bridge id _Nullable)([self scaleOutsidePath].CGPath);
    animation2.toValue   = (__bridge id _Nullable)([self normalOutsidePath].CGPath);
    animation2.fillMode  = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    [_outsideLayer addAnimation:animation2 forKey:@"outsideScale"];
    
    // 进度条复原
    [_timer invalidate];
    _timer = nil;
    _costTime = 0;
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    
    // 取消和选择按钮弹出,拍摄按钮隐藏
    self.cancelButton.hidden = NO;
    self.chooseButton.hidden = NO;
    self.popButton.hidden    = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.cancelButtonCenterX.constant = - self.bounds.size.width / 4;
        self.chooseButtonCenterX.constant = self.bounds.size.width / 4;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        self.innerLayer.hidden   = YES;
        self.outsideLayer.hidden = YES;
        self.shootButton.hidden  = YES;
    }];
}

// 设置缩放动画
- (void)setScaleAnimation
{
    self.popButton.hidden = YES;
    
    // 内圆半径变小
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration  = 0.25;
    animation.fromValue = (__bridge id _Nullable)([self normalInnerPath].CGPath);
    animation.toValue   = (__bridge id _Nullable)([self scaleInnerPath].CGPath);
    animation.fillMode  = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [_innerLayer addAnimation:animation forKey:@"innerScale"];
    
    // 外圆半径变大
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation2.duration  = 0.25;
    animation2.fromValue = (__bridge id _Nullable)([self normalOutsidePath].CGPath);
    animation2.toValue   = (__bridge id _Nullable)([self scaleOutsidePath].CGPath);
    animation2.fillMode  = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    [_outsideLayer addAnimation:animation2 forKey:@"outsideScale"];
    
    [self.shootButton.layer addSublayer:self.progressLayer];
    
    // 更新进度条
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown
{
    if(_costTime >= MaxTimeLength) {
        
        // 倒计时结束
        [_timer invalidate];
        _timer = nil;
        
        [self setNormalAnimation];
    }
    
    _costTime += 0.1;
    float end  = _costTime / MaxTimeLength;
    if (end >= 1) {
        end = 1;
    }
    self.progressLayer.strokeEnd = end;
    
    // 打印时间
    NSLog(@"耗时 %.1f s", _costTime);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    return (hitView == self) ? nil : hitView;
}


@end
