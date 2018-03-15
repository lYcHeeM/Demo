//
//  ZJActivityIndicatorView.m
//  ImageViewAnimation
//
//  Created by luozhijun on 16/1/25.
//  Copyright © 2016年 DDFinance. All rights reserved.
//

#import "ZJActivityIndicatorView.h"

NSString *const ZJActivityIndicatorViewAnimationKey = @"ZJActivityIndicatorViewAnimationKey";

@interface ZJActivityIndicatorView ()
@property (nonatomic, assign) ZJActivityIndicatorViewStyle style;
@property (nonatomic, assign) BOOL isIndicatorAnimating;
@end

@implementation ZJActivityIndicatorView

- (instancetype)initWithActivityIndicatorStyle:(ZJActivityIndicatorViewStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _hidesWhenStopped = YES;
        self.hidden = YES;
        _style = style;
        self.image = [[UIImage imageNamed:@"loading_imgBlue_60x60"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (_style == ZJActivityIndicatorViewStyleCircle) {
            self.bounds = (CGRect){CGPointZero, ZJActivityIndicatorViewDefaultSize};
        } else if (_style == ZJActivityIndicatorViewStyleCircleLarge) {
            self.bounds = (CGRect){CGPointZero, ZJActivityIndicatorViewLargeSize};
        }
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    self.tintColor = color;
}

- (CABasicAnimation *)_indicatorAnimation
{
    CABasicAnimation *animation   = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue           = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue             = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration            = 0.25;
    animation.cumulative          = YES;
    animation.repeatCount         = MAXFLOAT;
    animation.removedOnCompletion = NO;
    return animation;
}

- (void)startIndicatorAnimating
{
    self.hidden = NO;
    CAAnimation *animation = [self _indicatorAnimation];
    [self.layer addAnimation:animation forKey:ZJActivityIndicatorViewAnimationKey];
    self.isIndicatorAnimating = YES;
}

- (void)stopIndicatorAnimating
{
    [self.layer removeAnimationForKey:ZJActivityIndicatorViewAnimationKey];
    if (self.hidesWhenStopped) {
        self.hidden = YES;
        self.isIndicatorAnimating = NO;
    }
}

@end
